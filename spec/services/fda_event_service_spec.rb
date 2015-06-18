require 'spec_helper'

RSpec.describe FdaEventService do

  it "should return 10 results for a wide-scoped search" do 
    expect( FdaEventService.search("viagra")['results'].length ).to eq 10
  end

  describe "search on product ndc" do 

    before :each do 
      @lipitor_ndc = "0071-0156"
    end

    it "should return results for a specific ndc" do 
      # Lipitor has many events
      expect( FdaEventService.search_product_ndc(@lipitor_ndc)['results'].length ).to be > 9
    end

    it "should only have results that include the ndc" do 
      FdaEventService.search_product_ndc(@lipitor_ndc)['results'].each do |result|
        matches_within_patient = 0
        # crawl through the result set
        result['patient']['drug'].each do |drug|
          if drug['openfda'] && drug['openfda']['product_ndc']
            matches_within_patient +=1 if drug['openfda']['product_ndc'].include? @lipitor_ndc
          end
        end
        expect(matches_within_patient).to be >= 1
      end
    end

  end

end
