json.array!(@tasks) do |task|
  json.extract! task, :id, :name, :weight, :avatar_url, :sha1
  json.url task_url(task, format: :json)
end
