json.array!(@package_installations) do |package_installation|
  json.extract! package_installation, :id, :installed_version, :package_id, :system_id
  json.url package_installation_url(package_installation, format: :json)
end
