json.array!(@system_update_states) do |system_update_state|
  json.extract! system_update_state, :id, :name
  json.url system_update_state_url(system_update_state, format: :json)
end
