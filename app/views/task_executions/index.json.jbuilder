json.array!(@task_executions) do |task_execution|
  json.extract! task_execution, :id, :log
  json.url task_execution_url(task_execution, format: :json)
end
