require 'faker'

FactoryGirl.define do
  factory :package do
    name Faker::App.name
    section Faker::Lorem.word
    homepage Faker::Internet.url
    summary Faker::Lorem.paragraph
  end
end
