json.array!(@package_groups) do |package_group|
  json.extract! package_group, :id, :name, :permission_level
  json.url package_group_url(package_group, format: :json)
end
