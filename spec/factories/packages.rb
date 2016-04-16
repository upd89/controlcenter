require 'faker'

FactoryGirl.define do
  factory :package do |f|
    f.name { Faker::App.name }
    f.base_version Faker::App.version
  end
end
