json.array!(@distributions) do |distribution|
  json.extract! distribution, :id, :name
  json.url distribution_url(distribution, format: :json)
end
