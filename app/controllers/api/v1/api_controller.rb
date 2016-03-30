module Api::V1
  class ApiController < ApplicationController
    protect_from_forgery with: :null_session

    def updateSystem

      if System.exists?(params[:id])
        system = System.find(params[:id])

	if JSON.parse( request.body.read )
	  sysUpdate = JSON.parse request.body.read
  
          if sysUpdate["urn"] && sysUpdate["os"]
     	    system.urn = sysUpdate["urn"]
	    system.os = sysUpdate["os"]
	    #TODO: lastSeenAt
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

    def register
      if JSON.parse( request.body.read )

        sys = JSON.parse request.body.read

	if sys["urn"] && sys["os"]
          newSys = System.new
          newSys.urn = sys["urn"]
          newSys.os = sys["os"]
          newSys.save()

          render text: "OK"
        else
          render text: "ERROR 001"
        end
      else
        render text: "ERROR 000"
      end
    end

  end
end

