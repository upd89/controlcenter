json.array!(@concrete_package_versions) do |concrete_package_version|
  json.extract! concrete_package_version, :id, :system_id, :task_id, :concrete_package_state_id, :package_version_id
  json.url concrete_package_version_url(concrete_package_version, format: :json)
end
