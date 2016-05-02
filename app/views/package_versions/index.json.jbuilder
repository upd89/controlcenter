json.array!(@package_versions) do |package_version|
  json.extract! package_version, :id, :sha256, :version, :architecture, :package_id, :distribution_id, :repository_id, :is_base_version
  json.url package_version_url(package_version, format: :json)
end
