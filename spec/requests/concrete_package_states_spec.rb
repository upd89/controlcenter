require 'spec_helper'

RSpec.describe "ConcretePackageStates", type: :request do
  describe "GET /concrete_package_states" do
    it "works! (now write some real specs)" do
      get concrete_package_states_path
      expect(response).to have_http_status(200)
    end
  end
end
