require 'spec_helper'

RSpec.describe "Node API" do

  include Helpers::DrugHelpers

  before :each do 
    setup_drug_data
  end

  describe "drug-centered node" do 

    it "should get a valid object" do
      get "/api/v1/node/drug/#{@prozac.product_ndc}"
      expect(json["name"]).to eq @prozac.proprietary_name
    end

    it "includes children" do 
      get "/api/v1/node/drug/#{@prozac.product_ndc}"
      expect(json["children"]).to be_an Array
    end

    it 'finds no items for a bad identifier, and returns an error message' do 
      bad_id = "DJFKDJFKDJLSKJFLSDKJFLSDKFDKFJ"
      get "/api/v1/node/drug/#{bad_id}"
      expect(json["error"]).to be_present
    end

  end # drug


  describe "substance-centered node" do 

    it "should get a valid object" do
      get "/api/v1/node/substance/flubber"
      expect(json["name"]).to eq 'flubber'
    end

    it "includes children" do 
      get "/api/v1/node/substance/flubber"
      expect(json["children"]).to be_an Array
    end

    it 'finds no items for a bad identifier, and returns an error message' do 
      bad_id = "DJFKDJFKDJLSKJFLSDKJFLSDKFDKFJ"
      get "/api/v1/node/substance/#{bad_id}"
      expect(json["error"]).to be_present
    end

  end # manufacturer

  describe "manufacturer-centered node" do 

    it "should get a valid object" do
      get "/api/v1/node/manufacturer/ronco"
      expect(json["name"]).to eq 'ronco'
    end

    it "includes children" do 
      get "/api/v1/node/manufacturer/ronco"
      expect(json["children"]).to be_an Array
    end

    it 'finds no items for a bad identifier, and returns an error message' do 
      bad_id = "DJFKDJFKDJLSKJFLSDKJFLSDKFDKFJ"
      get "/api/v1/node/manufacturer/#{bad_id}"
      expect(json["error"]).to be_present
    end    

  end # manufacturer

end