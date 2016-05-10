require 'spec_helper'

describe Role do
  it "has a valid factory" do
    expect(FactoryGirl.create(:role)).to be_valid
  end

  it "is invalid without a name" do
    expect(FactoryGirl.build(:role, name: nil)).to be_invalid
  end
  it "is invalid without a permission_level" do
    expect(FactoryGirl.build(:role, permission_level: nil)).to be_invalid
  end
end
