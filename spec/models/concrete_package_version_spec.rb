require 'spec_helper'

RSpec.describe ConcretePackageVersion, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:concrete_package_version)).to be_valid
  end

  it "can create instance with version, sys and state" do
    cpv_state_avail = ConcretePackageState.create(name: "Available")
    pkg = Package.create(name: "Foo")
    pkgVersion = PackageVersion.create(package: pkg, version: "1.0.0", sha256: "ABC")
    sys = System.create(urn: "Bar")

    expect( ConcretePackageVersion.create_new( pkgVersion, sys, cpv_state_avail ) ).to be_valid
  end
end
