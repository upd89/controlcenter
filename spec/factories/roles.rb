require 'faker'

FactoryGirl.define do
  factory :role do |f|
    f.name { Faker::Company.profession }
    f.permission_level Faker::Number.between(0, 9)
  end
end
