require "net/http"
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


    #uri = URI.parse("http://upd89.org/api.php")

    # add http:// in front of URLs
    uri = URI.parse("http://" + system.address + "/task")

    http = Net::HTTP.new(uri.host, uri.port)

    request = Net::HTTP::Post.new(uri.request_uri)

    request.body = taskData.to_json

    response = http.request(request)
    p response.body
  end
end
