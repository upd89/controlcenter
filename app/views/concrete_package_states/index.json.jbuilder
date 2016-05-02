json.array!(@concrete_package_states) do |concrete_package_state|
  json.extract! concrete_package_state, :id, :name
  json.url concrete_package_state_url(concrete_package_state, format: :json)
end
