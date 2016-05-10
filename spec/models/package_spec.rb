require 'spec_helper'

RSpec.describe Package, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:package)).to be_valid
  end
end
