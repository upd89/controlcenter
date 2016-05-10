require 'faker'

FactoryGirl.define do
  factory :package_version do |f|
    f.sha256 Faker::Internet.password(64) #TODO use Faker::Crypto.sha256 in 1.6.9
    f.version Faker::App.version
    f.architecture Faker::Hipster.word
    f.package nil
    f.distribution nil
    f.repository nil
    f.is_base_version Faker::Boolean.boolean
  end
end
