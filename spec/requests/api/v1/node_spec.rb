require 'spec_helper'

RSpec.describe "Node API" do

  include Requests::DrugHelpers

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

  end # manufacturer

end