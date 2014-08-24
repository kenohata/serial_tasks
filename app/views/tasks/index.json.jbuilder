json.array!(@tasks) do |task|
  json.extract! task, :id, :name, :weight
  json.url task_url(task, format: :json)
end
