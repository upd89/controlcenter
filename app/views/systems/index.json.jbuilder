json.array!(@systems) do |system|
  json.extract! system, :id, :name, :urn, :os,
                :reboot_required, :address, :last_seen, :system_group_id
  json.url system_url(system, format: :json)
end
