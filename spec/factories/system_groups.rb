require 'faker'

FactoryGirl.define do
  factory :system_group do
    name Faker::Hacker.abbreviation
    permission_level Faker::Number.between(0, 100)
  end
end
