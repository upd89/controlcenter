require "net/https"
require "uri"

class BackgroundSender
  include SuckerPunch::Job

  def perform(task)
    packageArray = []
    task.concrete_package_versions.each do |pkgVersion|
      packageArray << { pkg_name: pkgVersion.package_version.package.name, pkg_version: pkgVersion.package_version.version}
    end

    system = task.concrete_package_versions.first().system
    taskData = { task_id: task.id.to_s, urn: system.name, packages: packageArray }
    task.tries = task.tries.to_i + 1

    url = 'https://' + system.address

    begin
      connection = Faraday::Connection.new url, :ssl => {
        :ca_path => 'config/certs',         #relative dir
        :client_cert => OpenSSL::X509::Certificate.new(File.read('config/clientCert/upd89-02.nine.ch.crt')),
        :client_key => OpenSSL::PKey::RSA.new(File.read('config/clientCert/upd89-02.nine.ch.key')),
        :version => 'TLSv1_2',
        :verify => true
      }

      result = connection.post '/task', taskData.to_json

      #handle both JSON and text reply
      if JSON.parse( result.body.read )
        status = JSON.parse result.body.read
        status = status["status"]
      else
        status = result.body
      end

      if status.downcase == "ok"
        task.task_state = TaskState.where(name: "Queued")[0]
      end
    #rescue Faraday::Error::ConnectionFailed => e #TODO: other possible errors
    rescue
      if task.tries.to_i < Settings.BackgroundTask.MaximumAmountOfTries
        BackgroundSender.perform_in(Settings.BackgroundTask.SecondsBetweenTries, task )
      else
        task.task_state = TaskState.where(name: "Not Delivered")[0]
        cpv_state_avail = ConcretePackageState.where(name: "Available")[0]
        task.concrete_package_versions.each do |cpv|
          cpv.concrete_package_state = cpv_state_avail
          cpv.save()
        end

      end
    ensure
      task.save()
    end
  end
end
