require 'spec_helper'

describe Role do
  it "has a valid factory" do
    FactoryGirl.create(:role).should be_valid
  end

  it "is invalid without a name" do
    FactoryGirl.build(:role, name: nil).should_not be_valid
  end
  it "is invalid without a permission_level" do
    FactoryGirl.build(:role, permission_level: nil).should_not be_valid
  end
end
