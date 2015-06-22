require 'spec_helper'

RSpec.describe FdaMedicationGuideService do

  before :each do 
    @expected_first = { 
      :brand_name=>"AnoroEllipta", 
      :link=>"http://www.fda.gov/downloads/Drugs/DrugSafety/UCM380278.pdf", 
      :generic_name=>"Umeclidinium; Vilanterol", 
      :version=>"2013 version"
    }
    @expected_last = {
      :brand_name=>"Zyprexa Relprevv", 
      :link=>"http://www.fda.gov/downloads/Drugs/DrugSafety/UCM194579.pdf", 
      :generic_name=>"olanzapine", 
      :version=>"2012 version"
    }
  end

  describe "scraping results" do

    it "should get many (>20) results" do 
      expect( FdaMedicationGuideService.scrape_data ).to be_an Array
      expect( FdaMedicationGuideService.scrape_data.length ).to be > 20
    end

    it "should correctly parse first result (with combined URL)" do 
      expect( FdaMedicationGuideService.scrape_data.first ).to eq @expected_first
    end

    it "should correctly parse last result (with combined URL)" do 
      expect( FdaMedicationGuideService.scrape_data.last ).to eq @expected_last
    end

  end # scraping results

  describe "importing data" do 

    before :each do 
      
      class FdaMedicationGuideService
        def scrape_data
          [ @expected_first, @expected_last ]
        end
      end

    end

    it "should import records based on the scrape results" do 
      expect( FdaMedicationGuideService.find(@expected_first[:brand_name]) ).to be_blank
      FdaMedicationGuideService.import_data
      expect( FdaMedicationGuideService.find(@expected_first[:brand_name])['generic_name'] ).to eq "Umeclidinium; Vilanterol"
    end

    it "should not duplicate records if they exist" do 
      FdaMedicationGuideService.import_data
      expect{
        FdaMedicationGuideService.import_data
      }.to_not change{FdaMedicationGuideService.all_records.count}
    end

  end

end
