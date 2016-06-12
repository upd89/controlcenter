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

      if check_mandatory_json_params(data, ["updCount", "packageUpdates"]) || !System.exists?(urn: urn)
        render json: { status: "ERROR" }
        return
      end

      render json: DataMutationService.updateSystemHash(urn, data)

    end

    # v2/system/:urn/notify
    def updateSystem
      urn = params[:urn]
      data = JSON.parse request.body.read

      if check_mandatory_json_params(data, ["updCount", "packageUpdates"]) || !System.exists?(urn: urn)
        render json: { status: "ERROR" }
        return
      end

      render json: DataMutationService.updateSystem(urn, data)

    end

    # v2/system/:urn/refresh-installed-hash
    def refreshInstalledHash
      urn = params[:urn]
      data = JSON.parse request.body.read

      if check_mandatory_json_params(data, ["pkgCount", "packages"]) || !System.exists?(urn: urn)
        render json: { status: "ERROR" }
        return
      end

      render json: DataMutationService.refreshInstalledHash(urn, data)

    end

    # v2/system/:urn/refresh-installed
    def refreshInstalled
      urn = params[:urn]
      data = JSON.parse request.body.read

      if check_mandatory_json_params(data, ["pkgCount", "packages"]) || !System.exists?(urn: urn)
        render json: { status: "ERROR" }
        return
      end

      render json: DataMutationService.refreshInstalled(urn, data)

    end

    # v2/task/:id/notify
    def updateTask
      taskid = params[:id]
      data = JSON.parse request.body.read

      if check_mandatory_json_params(data, ["state", "log"]) || !Task.exists?(taskid)
        render json: { status: "ERROR" }
        return
      end

      render json: DataMutationService.updateTask(taskid, data)

    end
  end
end
