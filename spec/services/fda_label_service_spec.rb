require 'spec_helper'

RSpec.describe FdaLabelService do

  describe "find by product ndc" do 

    before :each do 
      @lipitor_ndc = "0071-0156"
    end

    it "should return a result for a specific ndc" do 
      expect( FdaLabelService.find_by_product_ndc(@lipitor_ndc) ).to be_a Hash
      expect( FdaLabelService.find_by_product_ndc(@lipitor_ndc)["indications_and_usage"] ).to be_present
    end

    it "should return no result for a bad ndc" do 
      expect( FdaLabelService.find_by_product_ndc("dkdjkjkjdkjfkj3k3j43k4343") ).to_not be_present
    end

    describe "normalizing ndc format" do 

      it "should add a zero padding to product code" do 
        ndc = "55289-038"
        expect( FdaLabelService.find_by_product_ndc(ndc)["indications_and_usage"] ).to be_present
        ndc = "63868-0089"
        expect( FdaLabelService.find_by_product_ndc(ndc)["indications_and_usage"] ).to be_present
      end

    end # normalize

  end # find by product ndc"


end
