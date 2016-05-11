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

        sys.concrete_package_versions << assoc
        sys.save()
      end

      # TODO: assoc needed? maybe just error
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

      if System.exists?(:urn => data["urn"])
        render json: { status: "OK" }
        return
      end

      newSys = System.new
      apply_system_properties( newSys, data )
      newSys.system_group = SystemGroup.first
      newSys.last_seen = DateTime.now
      #newSys.certificate = request.headers['X-Api-Client-Cert'] #TODO: maybe save certi in the near future

      if newSys.save()
        render json: { status: "OK" }
      else
        render json: { status: "ERROR" }
      end
    end

    # v2/system/:urn/notify-hash
    def updateSystemHash
      data = JSON.parse request.body.read

      if check_mandatory_json_params(data, ["updCount", "packageUpdates"]) || !System.exists?(urn: params[:urn])
        render json: { status: "ERROR" }
        return
      end

      currentSys = System.where(urn: params[:urn])[0]

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
      apply_system_properties( currentSys, data )
      error = true unless currentSys.save()

      data["packageUpdates"].each do |update|
        if !Package.exists?( name: update['name'] )
          unknownPackages = true
        else
          pkg = Package.where( name: update['name'] )[0]
          newVersion = update['candidateVersion']

          if PackageVersion.exists?( sha256: newVersion['sha256'] )
            pkgVersion = PackageVersion.where( sha256: newVersion['sha256'] )[0]
          else
            pkgVersion = PackageVersion.create( {
              :sha256       => newVersion['sha256'],
              :version      => newVersion['version'],
              :architecture => newVersion['architecture'],
              :package      => pkg
            } )
          end

          if newVersion['sha256'] == update['baseVersionHash']
            # this is a base_version already, don't do anything
          elsif PackageVersion.exists?( sha256: update['baseVersionHash'] )
            pkgVersion.base_version = PackageVersion.where( sha256: update['baseVersionHash'] )[0]
            error = true unless pkgVersion.save()
          else
            # send pkgUnknown because the base version of this package is unknown
            unknownPackages = true
          end

          if update['repository']
            rep = update['repository']
            if Repository.exists?( archive: rep['archive'], origin: rep['origin'], component: rep['component'] )
              currentRepo = Repository.where( archive: rep['archive'], origin: rep['origin'], component: rep['component'] )[0]
            else
              currentRepo = Repository.create(archive: rep['archive'], origin: rep['origin'], component: rep['component'] )
            end
            pkgVersion.repository = currentRepo
          end

          # TODO: refactor distro handling
          if currentSys.os
            if Distribution.exists?(name: currentSys.os)
              dist = Distribution.where(name: currentSys.os)[0]
            else
              dist = Distribution.create(name: currentSys.os)
            end
            pkgVersion.distribution = dist
          end
          error = true unless pkgVersion.save()

          pkg.package_versions << pkgVersion
          error = true unless pkg.save()

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

      if currentSys.os
        if Distribution.exists?(name: currentSys.os)
          dist = Distribution.where(name: currentSys.os)[0]
        else
          dist = Distribution.create(name: currentSys.os)
        end
      end

      data["packages"].each do |package|
        # best case: we know the package (by name)
        if Package.exists?( name: package['name'] )
          currentPkg = Package.where( name: package['name'] )[0]
          # update package information if specified
          currentPkg.section  = package['section']  if package['section']
          currentPkg.homepage = package['homepage'] if package['homepage']
          currentPkg.summary  = package['summary']  if package['summary']
          error = true unless currentPkg.save()
        else
          # creating package
          currentPkg = Package.create( {
                 :name         =>  package['name'],
                 :section      =>  package['section'],
                 :homepage     =>  package['homepage'],
                 :summary      =>  package['summary']
          } )
        end

        installedVersion = package['installedVersion']

        # check if specified version exists
        if PackageVersion.exists?(package: currentPkg, sha256: installedVersion['sha256'])
          pkgVersion = PackageVersion.where(package: currentPkg, sha256: installedVersion['sha256'])[0]
          pkgVersion.version      = installedVersion['version']      if installedVersion['version']
          pkgVersion.architecture = installedVersion['architecture'] if installedVersion['architecture']
        else
          pkgVersion = PackageVersion.create({
             :package      => currentPkg,
             :version      => installedVersion['version'],
             :sha256       => installedVersion['sha256'],
             :architecture => installedVersion['architecture']
          })
        end

        # set or update distro
        if dist
          pkgVersion.distribution = dist
          error = true unless pkgVersion.save()
        end

        # set or update repository
        if package['repository']
          rep = package['repository']
          if Repository.exists?( archive: rep['archive'], origin: rep['origin'], component: rep['component'] )
            currentRepo = Repository.where( archive: rep['archive'], origin: rep['origin'], component: rep['component'] )[0]
          else
            currentRepo = Repository.create(archive: rep['archive'], origin: rep['origin'], component: rep['component'] )
          end
          pkgVersion.repository = currentRepo
          error = true unless pkgVersion.save()
        end

        create_new_concrete_package_version( pkgVersion, currentSys, stateInstalled )

        if !package['isBaseVersion']
          baseVersionJSON = package['baseVersion']
          if PackageVersion.exists?(sha256: baseVersionJSON['sha256'])
            pkgVersion.base_version = PackageVersion.where(sha256: baseVersionJSON['sha256'])[0]
            error = true unless pkgVersion.save()
          else
            # TODO: extract creation of new package version + concrete package version!!!
            baseVersion = PackageVersion.create({
               :package      => currentPkg,
               :version      => baseVersionJSON['version'],
               :sha256       => baseVersionJSON['sha256'],
               :architecture => baseVersionJSON['architecture']
            })

            # set or update distro
            if dist
              baseVersion.distribution = dist
              error = true unless baseVersion.save()
            end

            # set or update repository
            if baseVersionJSON['repository']
              rep = baseVersionJSON['repository']
              if Repository.exists?( archive: rep['archive'], origin: rep['origin'], component: rep['component'] )
                currentRepo = Repository.where( archive: rep['archive'], origin: rep['origin'], component: rep['component'] )[0]
              else
                currentRepo = Repository.create(archive: rep['archive'], origin: rep['origin'], component: rep['component'] )
              end
              baseVersion.repository = currentRepo
              error = true unless baseVersion.save()
            end

            create_new_concrete_package_version( baseVersion, currentSys, stateInstalled )

            pkgVersion.base_version = baseVersion
            error = true unless pkgVersion.save()

          end
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

      #TODO: check if task was already set to done or failed!

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
