require 'spec_helper'

RSpec.describe SystemGroup, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:system_group)).to be_valid
  end

  it "is invalid without a name" do
    expect(FactoryGirl.build(:system_group, name: nil)).to be_invalid
  end
end
