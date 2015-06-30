require 'spec_helper'

RSpec.describe "Drugs API" do

  include Helpers::DrugHelpers

  before :each do 
    setup_drug_data
  end

  describe "typeahead search" do 

    it "should provide results based on substring" do 
      get "/api/v1/drugs.json?q=ia"
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

    describe "valid (viagra) ndc" do 

      before :each do 
        get "/api/v1/drugs/#{@viagra.product_ndc}"
        @response = response
        @json = json
        sleep(0.5) # avoid API rate limit
      end

      it 'should provide a single object for a known drug' do
        expect(@response).to be_success 
        expect(@json["error"]).to_not be_present
        expect(@json["results"][0]["proprietary_name"]).to be_present
      end

      it 'should layer on event statistics' do 
        expect(@response).to be_success 
        expect(@json["results"][0]["event_data"]).to be_present
        expect(@json["results"][0]["event_data"][0]["label"] ).to be_a  String
        expect(@json["results"][0]["event_data"][0]["value"]).to be_an Integer
      end

      it 'should layer on NADAC, generics, and other data' do 
        # this has more than one assertion to avoid excess API calls
        expect(@response).to be_success 
        expect(@json["results"][0]["nadac"]).to be_an Array
        expect(@json["results"][0]["generics_list"]).to be_an Array
        expect(@json["results"][0]["generics_list"].first).to be_a Hash
        expect(@json["results"][0]["recall_list"]).to be_an Array
        expect(@json["results"][0]["medication_guide"]).to be_a Hash
        expect(@json["results"][0]["shortages"]).to be_an Array
        expect(@json["results"][0]["label"]).to be_a Hash
        expect(@json["results"][0]["label"]["storage_and_handling"]).to_not be_present
        expect(@json["results"][0]["routes"]).to be_an Array 
        expect(@json["results"][0]["substances"]).to be_an Array 
      end

      it 'should show streamlined field set for same pharma_class data' do 
        expect(@json["results"][0]["pharma_classes"]).to be_an Array
        expect(@json["results"][0]["pharma_classes"][0]["type"]).to be_present
        expect(@json["results"][0]["pharma_classes"][0]["drugs"]).to be_an Array
        expect(@json["results"][0]["pharma_classes"][0]["type"]).to be_present
      end

    end # valid ndc

    it 'should find no record and provides error for fake ndc' do
      fake_ndc = "9999-2343433422-2343434234234234235555"
      get "/api/v1/drugs/#{fake_ndc}"
      expect(json["error"]).to be_present
    end

  end # show

end