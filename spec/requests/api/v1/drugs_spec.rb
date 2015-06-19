require 'spec_helper'

RSpec.describe "Drugs API" do

  before :each do 
    @lipitor_ndc = "0071-0156"
    Drug.create(proprietary_name: 'Prozac',    product_ndc: '16590-843')
    Drug.create(proprietary_name: 'Viagra',    product_ndc: '55289-524')
    Drug.create(proprietary_name: 'Atripla',   product_ndc: '24236-292')
  end

  describe "typeahead search" do 

    it "should provide results based on substring" do 
      get "/api/v1/drugs.json?q=i"
      expect(json["results"].length).to eq 2
    end

    it "should be case insensitive" do 
      get "/api/v1/drugs.json?q=p"
      expect(json["results"].length).to eq 2
    end

    it "should provide no results for known un-matchable string" do 
      get "/api/v1/drugs.json?q=dkjkdjfkjdaslkfjdkjfslkdjfsdkljds"
      expect(json["results"].length).to eq 0
    end

    it "should provide no results for missing query string" do 
      get "/api/v1/drugs.json"
      expect(json["results"].length).to eq 0
    end

    it "should provide no results for empty query string" do 
      get "/api/v1/drugs.json?q="
      expect(json["results"].length).to eq 0
    end

  end

  describe "show" do 

    it 'should provide a single object for a known drug' do
      get "/api/v1/drugs/#{@lipitor_ndc}"
      expect(response).to be_success 
      expect(json["error"]).to_not be_present
      expect(json["openfda"]).to be_present
    end

    it 'should find no record and provides error for fake ndc' do
      fake_ndc = "9999-2343433422-2343434234234234235555"
      get "/api/v1/drugs/#{fake_ndc}"
      expect(json["error"]).to be_present
    end

    it 'should layer on event statistics' do 
      get "/api/v1/drugs/#{@lipitor_ndc}"
      expect(response).to be_success 
      expect(json["event_data"]).to be_present
      expect(json["event_data"][0]["term"] ).to be_a  String
      expect(json["event_data"][0]["count"]).to be_an Integer
    end

    it 'should layer on NADAC price data' do 
      get "/api/v1/drugs/#{@lipitor_ndc}"
      expect(response).to be_success 
      expect(json["nadac"]).to be_an Array
    end

    it 'should layer on generics data' do 
      get "/api/v1/drugs/#{@lipitor_ndc}"
      expect(json["generics_list"]).to be_an Array
    end

  end

end