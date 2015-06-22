require 'spec_helper'

RSpec.describe FdaShortageService do

  before :each do 
    @expected_first = { 
      :name=>"Acetohydroxamic Acid (Lithostat) Tablets", 
      :link=>"http://www.accessdata.fda.gov/scripts/drugshortages/dsp_ActiveIngredientDetails.cfm?AI=Acetohydroxamic%20Acid%20(Lithostat)%20Tablets&st=c&tab=tabs-1",
      :status=>"Currently in Shortage"
    }
    @expected_last = {
      :name=>"Zinc Injection", 
      :link=>"http://www.accessdata.fda.gov/scripts/drugshortages/dsp_ActiveIngredientDetails.cfm?AI=Zinc%20Injection&st=r&tab=tabs-1",
      :status=>"Resolved"
    }
    @discontinuation = {
      :name=>"Tositumomab and Iodine I 131 Tositumomab (Bexxar)", 
      :link=>"http://www.accessdata.fda.gov/scripts/drugshortages/dsp_ActiveIngredientDetails.cfm?AI=Tositumomab%20and%20Iodine%20I%20131%20Tositumomab%20(Bexxar)&st=d&tab=tabs-2",
      :status=>"Discontinued"
    }
  end

  describe "scraping results" do

    it "should get many (>20) results" do 
      expect( FdaShortageService.scrape_data ).to be_an Array
      expect( FdaShortageService.scrape_data.length ).to be > 20
    end

    it "should correctly parse first result (with combined URL)" do 
      expect( FdaShortageService.scrape_data ).to include @expected_first
    end

    it "should correctly parse last result (with combined URL)" do 
      expect( FdaShortageService.scrape_data ).to include @expected_last
    end

    it "should include discontinuations" do 
      expect( FdaShortageService.scrape_data ).to include @discontinuation
    end

  end # scraping results

  describe "importing & searching data" do 

    before :each do 
      
      class FdaShortageService
        def scrape_data
          [ @expected_first, @expected_last, @discontinuation ]
        end
      end

    end

    it "should import records based on the scrape results" do 
      expect( FdaShortageService.find(@expected_first[:name]) ).to be_blank
      FdaShortageService.import_data
      expect( FdaShortageService.find(@expected_first[:name])['status'] ).to eq "Currently in Shortage"
    end

    it "should not duplicate records if they exist" do 
      FdaShortageService.import_data
      expect{
        FdaShortageService.import_data
      }.to_not change{FdaShortageService.all_records.count}
    end

    describe "searching imported data" do 

      before :each do 
        FdaShortageService.import_data
      end

      it "should match based on generic name" do 
        expect( FdaShortageService.search_by_generic_name('Tositumomab').length ).to eq 1
      end

      it "should not find a non-matching term" do 
        expect( FdaShortageService.search_by_generic_name('djdjdjwhdhdhfjhjhjhSJh').length ).to eq 0
      end

    end # searching

  end # importing

end
