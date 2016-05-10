require 'faker'

FactoryGirl.define do
  factory :system do |f|
    f.urn Faker::Internet.domain_word
    f.name Faker::Superhero.name
    f.os Faker::App.name
    f.reboot_required false
    f.address Faker::Internet.public_ip_v4_address
    f.last_seen DateTime.now
    system_group
  end
end
