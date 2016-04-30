require 'faker'

FactoryGirl.define do
  factory :system do |f|
    f.urn { Faker::Superhero.name }
    #name "MyString"
    #os "MyString"
    #reboot_required false
    #address "MyString"
    #last_seen "2016-04-30 17:10:07"
    #system_group nil

  end
end
