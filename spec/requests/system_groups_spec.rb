require 'spec_helper'

RSpec.describe "SystemGroups", type: :request do
  describe "GET /system_groups" do
    it "works! (now write some real specs)" do
      get system_groups_path
      expect(response).to have_http_status(200)
    end
  end
end
