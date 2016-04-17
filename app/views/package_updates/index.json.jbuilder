json.array!(@package_updates) do |package_update|
  json.extract! package_update, :id, :candidate_version, :repository,
                :package_id
  json.url package_update_url(package_update, format: :json)
end
