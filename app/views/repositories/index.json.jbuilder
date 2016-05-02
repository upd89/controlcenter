json.array!(@repositories) do |repository|
  json.extract! repository, :id, :origin, :archive, :component
  json.url repository_url(repository, format: :json)
end
