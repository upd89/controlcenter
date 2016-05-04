require 'spec_helper'

describe "ControlCenter API v2" do

  describe "Register" do
    it 'checks if registering for the first time returns OK' do
      params = {
        name: Faker::StarWars.planet,
        urn: Faker::Internet.public_ip_v4_address + ":8080",
        os: Faker::Lorem.word,
        address: Faker::Internet.public_ip_v4_address,
        certificate: ""
      }
      post '/v2/register', params.to_json, {'ACCEPT' => "application/json", 'CONTENT_TYPE' => 'application/json'}

      expect(response).to be_success

      reply = JSON.parse response.body
      expect( reply["status"] ).to eq("OK")
    end

    it 'checks if registering a registered system returns OK' do
      params = {
        name: Faker::StarWars.planet,
        urn: Faker::Internet.public_ip_v4_address + ":8080",
        os: Faker::Lorem.word,
        address: Faker::Internet.public_ip_v4_address,
        certificate: ""
      }
      post '/v2/register', params.to_json, {'ACCEPT' => "application/json", 'CONTENT_TYPE' => 'application/json'}
      post '/v2/register', params.to_json, {'ACCEPT' => "application/json", 'CONTENT_TYPE' => 'application/json'}

      expect(response).to be_success

      reply = JSON.parse response.body
      expect( reply["status"] ).to eq("OK")
    end

    it 'checks if registering with a missing param returns ERROR' do
      params = { name: Faker::StarWars.planet }

      post '/v2/register', params.to_json, {'ACCEPT' => "application/json", 'CONTENT_TYPE' => 'application/json'}

      expect(response).to be_success

      reply = JSON.parse response.body
      expect( reply["status"] ).to eq("ERROR")
    end

  end

  describe "Notify Hash" do

    before(:each) do
      @system = FactoryGirl.create(:system)
      @package = FactoryGirl.create(:package)
      @packageVersion = FactoryGirl.create(:package_version, package: @package )
    end

    it 'checks if a call to a non-existent system fails' do
      params = {
        updCount: Faker::Number.number(10),
        packageUpdates: []
      }

      post '/v2/system/' + "almost" + @system.urn + '/notify-hash', params.to_json, {'ACCEPT' => "application/json", 'CONTENT_TYPE' => 'application/json'}

      expect(response).to be_success

      reply = JSON.parse response.body
      expect( reply["status"] ).to eq("ERROR")
    end

    it 'checks if a call with no hashes to an existing system succeeds' do
      params = {
        updCount: 0,
        packageUpdates: []
      }

      post '/v2/system/' + @system.urn + '/notify-hash', params.to_json, {'ACCEPT' => "application/json", 'CONTENT_TYPE' => 'application/json'}

      expect(response).to be_success

      reply = JSON.parse response.body
      expect( reply["status"] ).to eq("OK")
    end

    it 'checks if a known hash gets added to a system' do
      params = {
        updCount: 1,
        packageUpdates: [@packageVersion.sha256]
      }

      post '/v2/system/' + @system.urn + '/notify-hash', params.to_json, {'ACCEPT' => "application/json", 'CONTENT_TYPE' => 'application/json'}

      expect(response).to be_success

      reply = JSON.parse response.body
      expect( reply["status"] ).to eq("OK")
    end

    it 'checks if an unknown hash results in an error' do
      params = {
        updCount: 1,
        packageUpdates: ["fakeSHA256hash"]
      }

      post '/v2/system/' + @system.urn + '/notify-hash', params.to_json, {'ACCEPT' => "application/json", 'CONTENT_TYPE' => 'application/json'}

      expect(response).to be_success

      reply = JSON.parse response.body
      expect( reply["status"] ).to eq("infoIncomplete")
      expect( @system.packages.count ).to eq(0)
    end

    it 'checks if sending an already connected hash has no influence' do
      params = {
        updCount: 1,
        packageUpdates: [@packageVersion.sha256]
      }
      post '/v2/system/' + @system.urn + '/notify-hash', params.to_json, {'ACCEPT' => "application/json", 'CONTENT_TYPE' => 'application/json'}
      post '/v2/system/' + @system.urn + '/notify-hash', params.to_json, {'ACCEPT' => "application/json", 'CONTENT_TYPE' => 'application/json'}

      expect(response).to be_success

      reply = JSON.parse response.body
      expect( reply["status"] ).to eq("OK")
      expect( @system.packages.count ).to eq(1)
    end


  end

end
