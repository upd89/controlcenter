require 'spec_helper'

RSpec.describe Package, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:package)).to be_valid
  end

  it "has a permission_level of its group" do
    # grp = FactoryGirl.create(:package_group, permission_level: 5)
    grp = PackageGroup.create(name: "Test", permission_level: 5)
    pkg = FactoryGirl.create(:package)
    GroupAssignment.create( package: pkg, package_group: grp)

    expect(pkg.get_permission_level).to be 5
  end

  it "has a permission_level even if not in a group" do
    expect(FactoryGirl.create(:package).get_permission_level).to be 0
  end
end
