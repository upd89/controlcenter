require 'spec_helper'

RSpec.describe "ConcretePackageVersions", type: :request do
  describe "GET /concrete_package_versions" do
    it "works! (now write some real specs)" do
      get concrete_package_versions_path
      expect(response).to have_http_status(200)
    end
  end
end
