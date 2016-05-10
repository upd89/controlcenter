require 'faker'

FactoryGirl.define do
  factory :role do
    name Faker::Company.profession
    permission_level Faker::Number.between(0, 100)
  end
end
