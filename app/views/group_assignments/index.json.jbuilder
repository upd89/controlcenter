json.array!(@group_assignments) do |group_assignment|
  json.extract! group_assignment, :id, :package_group_id, :package_id
  json.url group_assignment_url(group_assignment, format: :json)
end
