require 'faker'

FactoryGirl.define do
  factory :system do |f|
    f.urn { Faker::Superhero.name }
  end
end
