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
        #      :ca_path => '/usr/lib/ssl/certs',  #original SSL dir
        #      :ca_path => '/opt/upd89/ca/keys',  #original upd89 cert dir
        :ca_path => 'config/certs',         #relative dir
        :client_cert => OpenSSL::X509::Certificate.new(File.read('config/clientCert/upd89-02.nine.ch.crt')),
        :client_key => OpenSSL::PKey::RSA.new(File.read('config/clientCert/upd89-02.nine.ch.key')),
        :version => 'TLSv1_2',
        :verify => true
      }

      #TODO: remove debug logging
      logger.debug( "------------CONN---------" )
      logger.debug( connection )

      result = connection.post '/task', taskData.to_json

      logger.debug( "------------BODY---------" )
      logger.debug( result.body )

      if ( result.body.downcase == "ok")
        task.task_state = TaskState.where(name: "Queued")[0]
      end
    #rescue Faraday::Error::ConnectionFailed => e #TODO: other possible errors
    rescue
      logger.debug( "Connection failed" ) #TODO: log exception!
      if task.tries.to_i < Settings.BackgroundTask.MaximumAmountOfTries
        logger.debug( "RESTARTING TASK " + task.tries.to_s )
        BackgroundSender.perform_in(Settings.BackgroundTask.SecondsBetweenTries, task )
      else
        task.task_state = TaskState.where(name: "Not Delivered")[0]
        stateAvailable = ConcretePackageState.where(name: "Available")[0]
        task.concrete_package_versions.each do |pkgVersion|
          pkgVersion.concrete_package_state = stateAvailable
          pkgVersion.save()
        end
  
      end
    ensure
      task.save()
    end
  end
end
