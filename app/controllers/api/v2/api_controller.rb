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
      urn = params[:urn]
      data = JSON.parse request.body.read

      if check_mandatory_json_params(data, ["updCount", "packageUpdates"]) || !System.exists?(urn: params[:urn])
        render json: { status: "ERROR" }
        return
      end

      render json: DataMutationService.updateSystemHash(urn, data)

    end

    # v2/system/:urn/notify
    def updateSystem
      urn = params[:urn]
      data = JSON.parse request.body.read

      if check_mandatory_json_params(data, ["updCount", "packageUpdates"]) || !System.exists?(urn: params[:urn])
        render json: { status: "ERROR" }
        return
      end

      render json: DataMutationService.updateSystem(urn, data)

    end

    # v2/system/:urn/refresh-installed-hash
    def refreshInstalledHash
      urn = params[:urn]
      data = JSON.parse request.body.read

      if check_mandatory_json_params(data, ["pkgCount", "packages"]) || !System.exists?(:urn => urn)
        render json: { status: "ERROR" }
        return
      end

      render json: DataMutationService.refreshInstalledHash(urn, data)

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

        ConcretePackageVersion.create_new(pkgVersion, currentSys, stateInstalled)

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

          ConcretePackageVersion.create_new(baseVersion, currentSys, stateInstalled)

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
