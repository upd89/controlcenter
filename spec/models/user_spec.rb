require 'spec_helper'

describe User do
  it "has a valid factory" do
    expect(FactoryGirl.create(
      :user,
      role: FactoryGirl.create(:role),
      password: "asdasdasd",
      password_confirmation: "asdasdasd"
    )).to be_valid
  end

  it "is invalid without a name" do
    expect(FactoryGirl.build(
      :user,
      name: nil,
      password: "asdasdasd",
      password_confirmation: "asdasdasd"
    )).to be_invalid
  end

  it "is invalid without a role" do
    expect(FactoryGirl.build(
      :user,
      role: nil,
      password: "asdasdasd",
      password_confirmation: "asdasdasd"
    )).to be_invalid
  end

  it "requires at least 8 chars" do
    expect(FactoryGirl.build(
      :user,
      role: FactoryGirl.build(:role),
      password: "1",
      password_confirmation: "1"
    )).to be_invalid
  end

  it "makes sure that emails are unique" do
    role = FactoryGirl.build(:role)
    user1 = FactoryGirl.create(:user, email: "asd", role: role)
    user2 = FactoryGirl.build(:user, email: "asd", role: role)
    expect( user2 ).to be_invalid
  end
end
