require 'spec_helper'

describe User do
  it "has a valid factory" do
    role = FactoryGirl.create(:role)
    FactoryGirl.create(:user, role: role).should be_valid
  end

  it "is invalid without a name" do
    FactoryGirl.build(:user, name: nil).should_not be_valid
  end
  it "is invalid without a role" do
    FactoryGirl.build(:user, role: nil).should_not be_valid
  end
end
