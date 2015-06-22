require 'spec_helper'

RSpec.describe FdaEnforcementService do

  describe "search on product ndc" do 

    before :each do 
      @recall_ndc = "0009-0775"
    end

    it "should return results for a specific ndc" do 
      # Lipitor has many events
      expect( FdaEnforcementService.search_product_ndc(@recall_ndc)['results'].length ).to be > 0
    end

    it "should only have results that include the ndc" do 
      FdaEnforcementService.search_product_ndc(@recall_ndc)['results'].each do |result|
        expect( result['openfda']['product_ndc'].include? @recall_ndc )
      end
    end

    it "should not return results for an ndc with no recalls" do 
      # Lipitor has many events
      expect( FdaEnforcementService.search_product_ndc("99999-999")["error"] ).to be_present
    end

  end # search on product ndc"

end
