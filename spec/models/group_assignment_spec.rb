require 'spec_helper'

RSpec.describe GroupAssignment, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:group_assignment)).to be_valid
  end
end
