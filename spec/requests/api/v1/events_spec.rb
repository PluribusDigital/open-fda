require 'spec_helper'

RSpec.describe "Events API" do

  before :each do 
    @ndc = "0071-0156"
    @brand_name = "Lipitor"
    @term = "Dizziness"
  end

  describe "getting list of events" do 

    it 'sends a list of events with a valid (and popular) ndc' do
      get "/api/v1/events?product_ndc=#{@ndc}"
      expect(response).to be_success 
      expect(json["error"]).to_not be_present
      expect(json["results"].length).to eq 10 
    end

    it 'finds no events for a fake ndc' do
      fake_ndc = "9999-2343433422-2343434234234234235555"
      get "/api/v1/events?product_ndc=#{fake_ndc}"
      expect(json["error"]).to be_present
    end

    it 'finds events using a popular brand_name and term' do 
      get "/api/v1/events?brand_name=#{@brand_name}&term=#{@term}"
      expect(json["error"]).to_not be_present
      expect(json["results"].length).to eq 10 
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