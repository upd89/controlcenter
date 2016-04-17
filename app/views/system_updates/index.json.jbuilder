json.array!(@system_updates) do |system_update|
  json.extract! system_update, :id, :system_update_state_id, :package_update_id,
                :system_id, :task_id
  json.url system_update_url(system_update, format: :json)
end
