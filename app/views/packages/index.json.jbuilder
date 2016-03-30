json.array!(@packages) do |package|
  json.extract! package, :id, :name, :base_version, :architecture, :section, :repository, :homepage, :summary
  json.url package_url(package, format: :json)
end
