json.array!(@system_groups) do |system_group|
  json.extract! system_group, :id, :name, :permission_level
  json.url system_group_url(system_group, format: :json)
end
