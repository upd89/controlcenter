module Api::V1
  class ApiController < ApplicationController
    protect_from_forgery with: :null_session

    # /register
    def register
      if JSON.parse( request.body.read )
        sys = JSON.parse request.body.read
	if sys["urn"] && sys["os"] && sys["address"]
          newSys = System.new
          newSys.name = sys["name"] if sys["name"]
          newSys.urn = sys["urn"]
          newSys.os = sys["os"]
          newSys.address = sys["address"]
          newSys.system_group = SystemGroup.first
          newSys.last_seen = DateTime.now
          newSys.save()
          render text: "OK"
        else
          render text: "Missing params"
        end
      else
        render text: "No JSON body"
      end
    end

    # /system/:id/notify
    def updateSystem
      if System.exists?(urn: params[:id])
        system = System.where(urn: params[:id])[0]
	if JSON.parse( request.body.read )
	  sysUpdate = JSON.parse request.body.read
          if sysUpdate["urn"] && sysUpdate["os"]
            system.name = sysUpdate["name"] if sysUpdate["name"]
     	    system.urn = sysUpdate["urn"]
            system.address = sysUpdate["address"] if sysUpdate["address"]
	    system.os = sysUpdate["os"]
            system.reboot_required = sysUpdate["reboot_required"] if sysUpdate["reboot_required"]
            system.last_seen = DateTime.now
	    system.save()
	    render text: "OK"
          else
	    render text: "Missing params"
	  end
        else
	  render text: "No JSON body"
        end
      else
	render text: "System doesn't exist"
      end
    end

    # /task/:id/notify
    def updateTask
      if Task.exists?(params[:id])
        task = Task.find(params[:id])

        if JSON.parse( request.body.read )
          taskUpdate = JSON.parse request.body.read

          if taskUpdate["state"]
            task.taskstate = taskUpdate["state"]
            task.save()

            render text: "OK"
          else
            render text: "Missing params"
          end
        else
          render text: "No JSON body"
        end
      else
        render text: "Task doesn't exist"
      end
    end

    # /system/:id/updateInstalled
    def updateInstalled
    end

  end
end

