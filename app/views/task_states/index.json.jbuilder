json.array!(@task_states) do |task_state|
  json.extract! task_state, :id, :name
  json.url task_state_url(task_state, format: :json)
end
