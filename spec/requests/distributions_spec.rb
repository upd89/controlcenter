require 'spec_helper'

RSpec.describe "Distributions", type: :request do
  describe "GET /distributions" do
    it "works! (now write some real specs)" do
      get distributions_path
      expect(response).to have_http_status(200)
    end
  end
end
