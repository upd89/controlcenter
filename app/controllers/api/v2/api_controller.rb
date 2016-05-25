module Api::V2
  class ApiController < ApplicationController
    protect_from_forgery with: :null_session
    skip_before_action :require_login

    before_action :require_valid_json

    def require_valid_json
      unless JSON.parse( request.body.read)
        render json: { status: "ERROR" }
        return
      end
    end

    def check_mandatory_json_params( data, params=[""] )
      error = false
      params.each do |param|
        error = true unless data.keys.include?(param)
      end
      return error
    end

    def apply_system_properties( sys, data )
      sys.name = data["name"] if data["name"]
      sys.urn = data["urn"] if data["urn"]
      sys.os = data["os"] if data["os"]
      sys.address = data["address"] if data["address"]
      sys.reboot_required = data["rebootRequired"] if data["rebootRequired"]
      sys.last_seen = DateTime.now
    end

    def create_new_concrete_package_version( pkgVersion, sys, state )
      # TODO: service to get package states...
      state = ConcretePackageState.first unless defined? state

      if ConcretePackageVersion.exists?( package_version: pkgVersion, system: sys )
        assoc = ConcretePackageVersion.where( package_version: pkgVersion, system: sys )[0]
        assoc.concrete_package_state = state
        assoc.save()
      else
        assoc = ConcretePackageVersion.new
        assoc.system = sys
        assoc.package_version = pkgVersion
        assoc.concrete_package_state = state
        assoc.save()

        # should alredy be set by setting system in assoc
        #sys.concrete_package_versions << assoc
        #sys.save()
      end

      return assoc
    end

    # v2/register
    def register
      data = JSON.parse request.body.read

      #if check_mandatory_json_params(data, ["name", "urn", "os", "address"])
      #   || !request.headers['X-Api-Client-Cert'] #TODO deny if no client cert was given
      #   || !request.headers['X-Api-Client-CN']
      #   || request.headers['X-Api-Client-CN'] != data['name']
      if check_mandatory_json_params(data, ["name", "urn", "os", "address"])
        render json: { status: "ERROR" }
        return
      end

      render json: DataMutationService.register(data)

    end

    # v2/system/:urn/notify-hash
    def updateSystemHash
      data = JSON.parse request.body.read

      if check_mandatory_json_params(data, ["updCount", "packageUpdates"]) || !System.exists?(urn: params[:urn])
        render json: { status: "ERROR" }
        return
      end

      currentSys = System.where(urn: params[:urn])[0]
      currentSys.update_last_seen()
      apply_system_properties( currentSys, data )
      currentSys.save()

      unknownPackages = []
      knownPackages = []
      stateAvailable = ConcretePackageState.first

      data["packageUpdates"].each do |updHash|
        if PackageVersion.exists?( sha256: updHash )
          knownPackages.push( updHash )

          pkgVersion = PackageVersion.where( sha256: updHash )[0]

          create_new_concrete_package_version( pkgVersion, currentSys, stateAvailable )
        else
          unknownPackages.push( updHash )
        end
      end
      currentSys.save()

      if unknownPackages.length > 0
        render json: { status: "infoIncomplete", knownPackages: knownPackages }
      elsif currentSys.concrete_package_versions.where(concrete_package_state: ConcretePackageState.where(name: "Available")[0]).count != data["updCount"]
        render json: { status: "countMismatch", knownPackages: knownPackages }
      else
        render json: { status: "OK", knownPackages: knownPackages  }
      end
    end

    # v2/system/:urn/notify
    def updateSystem
      data = JSON.parse request.body.read

      if check_mandatory_json_params(data, ["updCount", "packageUpdates"]) || !System.exists?(urn: params[:urn])
        render json: { status: "ERROR" }
        return
      end

      stateAvailable = ConcretePackageState.first
      error = false
      unknownPackages = false

      currentSys = System.where(urn: params[:urn])[0]
      currentSys.update_last_seen()
      apply_system_properties( currentSys, data )
      error = true unless currentSys.save()

      data["packageUpdates"].each do |update|
        if !Package.exists?( name: update['name'] )
          unknownPackages = true
        else
          pkg = Package.where( name: update['name'] )[0]
          newVersion = update['candidateVersion']

          pkgVersion = PackageVersion.get_maybe_create(newVersion, pkg)

          if newVersion['sha256'] == update['baseVersionHash']
            # this is a base_version already, don't do anything
          elsif PackageVersion.exists?( sha256: update['baseVersionHash'] )
            pkgVersion.base_version = PackageVersion.where( sha256: update['baseVersionHash'] )[0]
            error = true unless pkgVersion.save()
          else
            # send pkgUnknown because the base version of this package is unknown
            unknownPackages = true
          end

          if newVersion['repository']
            pkgVersion.repository = Repository.get_maybe_create(newVersion['repository'])
          end

          if currentSys.os
            pkgVersion.distribution = Distribution.get_maybe_create(currentSys.os)
          end
          error = true unless pkgVersion.save()

          # should alredy be set by creating the package version
          #pkg.package_versions << pkgVersion
          #error = true unless pkg.save()

          create_new_concrete_package_version( pkgVersion, currentSys, stateAvailable )
        end
      end

      if error
        render json: { status: "ERROR" }
      elsif unknownPackages
        render json: { status: "pkgUnknown" }
      elsif currentSys.concrete_package_versions.where(concrete_package_state: ConcretePackageState.where(name: "Available")[0]).count != data["updCount"]
        render json: { status: "countMismatch" }
      else
        render json: { status: "OK" }
      end
    end

    # v2/system/:urn/refresh-installed-hash
    def refreshInstalledHash
      data = JSON.parse request.body.read

      if check_mandatory_json_params(data, ["pkgCount", "packages"]) || !System.exists?(:urn => params["urn"])
        render json: { status: "ERROR" }
        return
      end

      unknownPackages = []
      knownPackages = []
      error = false
      stateInstalled = ConcretePackageState.last

      currentSys = System.where(urn: params[:urn])[0]
      currentSys.update_last_seen()

      # for each hash, check if this corresponds to a known version
      data["packages"].each do |pkgHash|
        if PackageVersion.exists?( sha256: pkgHash )
          pkgVersion = PackageVersion.where( sha256: pkgHash )[0]
          create_new_concrete_package_version( pkgVersion, currentSys, stateInstalled )

          knownPackages.push( pkgHash )
        else
          unknownPackages.push( pkgHash )
        end
      end

      if error
        render json: { status: "ERROR" }
      elsif unknownPackages.length > 0
        render json: { status: "infoIncomplete", knownPackages: knownPackages }
      elsif currentSys.packages.count != data["pkgCount"]
        render json: { status: "countMismatch", knownPackages: knownPackages  }
      else
        render json: { status: "OK", knownPackages: knownPackages  }
      end
    end

    # v2/system/:urn/refresh-installed
    def refreshInstalled
      data = JSON.parse request.body.read

      if check_mandatory_json_params(data, ["pkgCount", "packages"]) || !System.exists?(:urn => params["urn"])
        render json: { status: "ERROR" }
        return
      end

      error = false
      stateInstalled = ConcretePackageState.last
      currentSys = System.where(urn: params[:urn])[0]
      currentSys.update_last_seen()

      if currentSys.os
          dist = Distribution.get_maybe_create(currentSys.os)
      end

      data["packages"].each do |package|
        currentPkg = Package.get_maybe_create(package)
        installedVersion = package['installedVersion']
        pkgVersion = PackageVersion.get_maybe_create(installedVersion, currentPkg)

        # set or update distro
        if dist
          pkgVersion.distribution = dist
          error = true unless pkgVersion.save()
        end

        # set or update repository
        if installedVersion['repository']
          pkgVersion.repository = Repository.get_maybe_create(installedVersion['repository'])
          error = true unless pkgVersion.save()
        end

        create_new_concrete_package_version( pkgVersion, currentSys, stateInstalled )

        if !package['isBaseVersion']
          baseVersionJSON = package['baseVersion']

          baseVersion = PackageVersion.get_maybe_create(baseVersionJSON, currentPkg)

          pkgVersion.base_version = baseVersion
          error = true unless pkgVersion.save()

          # set or update distro
          if dist
              baseVersion.distribution = dist
              error = true unless baseVersion.save()
          end

          # set or update repository
          if baseVersionJSON['repository']
              baseVersion.repository = Repository.get_maybe_create(baseVersionJSON['repository'])
              error = true unless baseVersion.save()
          end

          create_new_concrete_package_version( baseVersion, currentSys, stateInstalled )

          pkgVersion.base_version = baseVersion
          error = true unless pkgVersion.save()

        end

      end

      if error
        render json: { status: "ERROR" }
      elsif currentSys.packages.count != data["pkgCount"]
        render json: { status: "countMismatch" }
      else
        render json: { status: "OK" }
      end
    end

    # v2/task/:id/notify
    def updateTask
      data = JSON.parse request.body.read
      error = false

      if check_mandatory_json_params(data, ["state", "log"]) || !Task.exists?(params[:id])
        render json: { status: "ERROR" }
        return
      end

      task = Task.find(params[:id])
      state = TaskState.where(:name => data["state"] ).first
      if state
        task.task_state = state
        # TODO + log
      end

      if data["log"]
        task.task_execution = TaskExecution.create(log: data["log"] )
      end

      if data["state"].downcase == "done"
        pkg_state = ConcretePackageState.where(name: "Installed").first
      else
        pkg_state = ConcretePackageState.where(name: "Available").first
      end

      task.concrete_package_versions.each do |cpv|
        cpv.concrete_package_state = pkg_state
        error = true unless cpv.save()
      end

      error = true unless task.save()

      if error
        render json: { status: "ERROR" }
      else
        render json: { status: "OK"  }
      end

    end
  end
end
