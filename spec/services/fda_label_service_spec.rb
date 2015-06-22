require 'spec_helper'

RSpec.describe FdaLabelService do

  describe "find by product ndc" do 

    before :each do 
      @lipitor_ndc = "0071-0156"
    end

    it "should return a result for a specific ndc" do 
      expect( FdaLabelService.find_by_product_ndc(@lipitor_ndc) ).to be_a Hash
      expect( FdaLabelService.find_by_product_ndc(@lipitor_ndc)["openfda"]["brand_name"] ).to be_present
    end

    it "should return no result for a bad ndc" do 
      expect( FdaLabelService.find_by_product_ndc("dkdjkjkjdkjfkj3k3j43k4343") ).to_not be_present
    end

    describe "normalizing ndc format" do 

      it "should add a zero padding to product code" do 
        ndc = "55289-038"
        expect( FdaLabelService.find_by_product_ndc(ndc)["openfda"]["brand_name"] ).to be_present
      end

    end # normalize

  end # find by product ndc"

  describe "search by pharm class" do 

    it "should find results for a known pharm class" do
      expect( FdaLabelService.search_by_class("Benzodiazepine [EPC]") ).to be_an Array
      expect( FdaLabelService.search_by_class("Benzodiazepine [EPC]").length ).to be > 0
    end

    it "should not find results for a bad pharm class" do
      expect( FdaLabelService.search_by_class("XHKDKDKJKAJEKDJKDJF") ).to be_an Array
      expect( FdaLabelService.search_by_class("XHKDKDKJKAJEKDJKDJF").length ).to be == 0
    end

  end

end
