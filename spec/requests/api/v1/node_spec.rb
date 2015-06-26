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

end