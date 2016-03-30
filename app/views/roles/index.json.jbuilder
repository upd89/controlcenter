json.array!(@roles) do |role|
  json.extract! role, :id, :name, :permission_level
  json.url role_url(role, format: :json)
end
