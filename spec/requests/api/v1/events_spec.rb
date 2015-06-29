require 'spec_helper'

RSpec.describe "Events API" do

  before :each do 
    @ndc = "0071-0156"
    @brand_name = "Lipitor"
    @term = "Dizziness"
  end

  describe "getting list of events" do 

    before :each do 
      sleep(0.3) # avoid API rate limit
    end

    it 'sends a list of events, with a subset of fields, with a valid (and popular) brand name' do
      get "/api/v1/events?brand_name=#{@brand_name}&term="
      expect(response).to be_success 
      expect(json["error"]).to_not be_present
      expect(json["results"]["event_details"].length).to be > 9
      # additional assertions to avoid excess API calls
      expect(json["results"]["event_details"].first["receivedate"]).to be_present
      expect(json["results"]["event_details"].first["serious"]).to be_present
      expect(json["results"]["event_details"].first["transmissiondateformat"]).to_not be_present
    end

    it 'finds events using a popular brand_name and term' do 
      get "/api/v1/events?brand_name=#{@brand_name}&term=#{@term}"
      expect(json["error"]).to_not be_present
      expect(json["results"]["event_details"].length).to be > 9 
    end

    it 'finds no events for a bad brand' do 
      bad_brand = "SUPERCALIFRAGILIXIOLMAX"
      get "/api/v1/events?brand_name=#{bad_brand}&term=#{@term}"
      expect(json["error"]).to be_present
    end

    it 'finds no events for a bad term' do 
      bad_term = "UNFEELINGWELLLISHNESS"
      get "/api/v1/events?brand_name=#{@brand_name}&term=#{bad_term}"
      expect(json["error"]).to be_present
    end

  end

end
