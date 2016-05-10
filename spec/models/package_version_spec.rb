require 'spec_helper'

RSpec.describe PackageVersion, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:package_version)).to be_valid
  end
end
