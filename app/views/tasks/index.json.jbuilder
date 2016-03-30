json.array!(@tasks) do |task|
  json.extract! task, :id, :task_state_id, :task_execution_id, :job_id
  json.url task_url(task, format: :json)
end
