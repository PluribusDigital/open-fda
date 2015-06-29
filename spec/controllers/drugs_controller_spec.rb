require 'spec_helper'

RSpec.describe API::V1::DrugsController do

  include Requests::DrugHelpers

  before :each do 
    setup_drug_data
    @api_regex=/.*fda.gov*/
  end

  it "should get index (quicksearch)" do 
    get :index, :q => '', :format => :json
    expect(response.status).to eq(200)
  end

  describe "show" do 

    it "should be successful" do 
      get :show, :id => @viagra.product_ndc, :format => :json
      expect(response.status).to eq(200)
    end

    it "should handle empty results from any given external API" do 
      WebMock.disable_net_connect!
      stub_request(:any, @api_regex)
        .to_return(:status => 200, :headers => {}, :body => '{
          error: { code: "NOT_FOUND", message: "No matches found!"}
        }')
      get :show, :id => @viagra.product_ndc, :format => :json
      expect(response.status).to eq(200)
      WebMock.allow_net_connect!
    end

    it "should handle empty results for generics" do 
      get :show, :id => @cialis.product_ndc, :format => :json
      expect(response.status).to eq(200)
    end

  end

  

end
