require 'spec_helper'

RSpec.describe NadacService do

  before :each do 
    @worksheet_data = [
      [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
      ["CMS", nil, nil, nil, nil, nil, nil, nil, nil],
      ["Monthly NADAC Reference File as of 06/17/2015", nil, nil, nil, nil, nil, nil, nil, nil],
      ["NDC Description","NDC","NADAC\nPer Unit","Effective\nDate","Pricing\nUnit","Pharmacy\nType\nIndicator","OTC","Explanation\nCode","Classification\nfor Rate\nSetting","Corresponding\nGeneric Drug\nNADAC\nPer Unit","Corresponding\nGeneric Drug\nEffective\nDate",nil],
      ["12-HR DECONGEST 120 MG CAPLET", "00113005452", 0.36651, "Wed, 17 Jun 2015 00:00:00 +0000", "EA", "C/I", "Y", "1", "G", nil, nil, nil],
      ["12-HR DECONGEST 120 MG CAPLET", "36800005452", 0.36651, "Wed, 17 Jun 2015 00:00:00 +0000", "EA", "C/I", "Y", "1", "G", nil, nil, nil],
      ["12-HR DECONGEST 120 MG CAPLET", "36800005460", 0.36651, "Wed, 17 Jun 2015 00:00:00 +0000", "EA", "C/I", "Y", "1", "G", nil, nil, nil],
      ["12-HR DECONGEST 120 MG CAPLET", "37205044652", 0.36651, "Wed, 17 Jun 2015 00:00:00 +0000", "EA", "C/I", "Y", "1", "G", nil, nil, nil],
      ["8 HOUR ER 650 MG CAPLET", "46122006271", 0.06081, "Wed, 17 Jun 2015 00:00:00 +0000", "EA", "C/I", "Y", "1", "G", nil, nil, nil],
      ["8 HOUR ER 650 MG CAPLET", "46122006278", 0.06081, "Wed, 17 Jun 2015 00:00:00 +0000", "EA", "C/I", "Y", "1", "G", nil, nil, nil],
      ["ABACAVIR 300 MG TABLET", "00378410591", 3.78621, "Wed, 17 Jun 2015 00:00:00 +0000", "EA", "C/I", "N", "1", "G", nil, nil, nil],
      ["ABACAVIR 300 MG TABLET", "31722055760", 3.78621, "Wed, 17 Jun 2015 00:00:00 +0000", "EA", "C/I", "N", "1", "G", nil, nil, nil],
      ["ABACAVIR 300 MG TABLET", "51079020401", 3.78621, "Wed, 17 Jun 2015 00:00:00 +0000", "EA", "C/I", "N", "1", "G", nil, nil, nil],
      ["ABACAVIR 300 MG TABLET", "51079020406", 3.78621, "Wed, 17 Jun 2015 00:00:00 +0000", "EA", "C/I", "N", "1", "G", nil, nil, nil],
      ["ABACAVIR 300 MG TABLET", "60505358306", 3.78621, "Wed, 17 Jun 2015 00:00:00 +0000", "EA", "C/I", "N", "1", "G", nil, nil, nil],
      ["ABACAVIR 300 MG TABLET", "65862007360", 3.78621, "Wed, 17 Jun 2015 00:00:00 +0000", "EA", "C/I", "N", "1", "G", nil, nil, nil],
      ["ABACAVIR 300 MG TABLET", "68084002111", 3.78621, "Wed, 17 Jun 2015 00:00:00 +0000", "EA", "C/I", "N", "1", "G", nil, nil, nil],
      ["ABACAVIR 300 MG TABLET", "68084002121", 3.78621, "Wed, 17 Jun 2015 00:00:00 +0000", "EA", "C/I", "N", "1", "G", nil, nil, nil],
      ["ABACAVIR-LAMIVUDINE-ZIDOV TAB", "68180028607", 23.0361, "Wed, 17 Jun 2015 00:00:00 +0000", "EA", "C/I", "N", "1", "G", nil, nil, nil],
      ["ABILIFY 1 MG/ML SOLUTION", "59148001315", 6.32127, "Thu, 01 Jan 2015 00:00:00 +0000", "ML", "C/I", "N", "2, 5", "B", nil, nil, nil],
      ["ABILIFY 10 MG TABLET", "59148000813", 29.12445, "Thu, 01 Jan 2015 00:00:00 +0000", "EA", "C/I", "N", "2", "B", nil, nil, nil],
      ["ABILIFY 10 MG TABLET", "59148000835", 29.12445, "Thu, 01 Jan 2015 00:00:00 +0000", "EA", "C/I", "N", "2", "B", nil, nil, nil],
      ["ABILIFY 15 MG TABLET", "59148000913", 29.03899, "Thu, 01 Jan 2015 00:00:00 +0000", "EA", "C/I", "N", "2", "B", nil, nil, nil],
      ["ABILIFY 15 MG TABLET", "59148000935", 29.03899, "Thu, 01 Jan 2015 00:00:00 +0000", "EA", "C/I", "N", "2", "B", nil, nil, nil],
      ["ABILIFY 2 MG TABLET", "59148000613", 28.72033, "Wed, 22 Apr 2015 00:00:00 +0000", "EA", "C/I", "N", "2", "B", nil, nil, nil],
      ["ABILIFY 20 MG TABLET", "59148001013", 40.91995, "Thu, 01 Jan 2015 00:00:00 +0000", "EA", "C/I", "N", "2", "B", nil, nil, nil],
      ["ABILIFY 20 MG TABLET", "59148001035", 40.91995, "Thu, 01 Jan 2015 00:00:00 +0000", "EA", "C/I", "N", "2", "B", nil, nil, nil],
      ["ABILIFY 30 MG TABLET", "59148001113", 40.98323, "Thu, 01 Jan 2015 00:00:00 +0000", "EA", "C/I", "N", "2", "B", nil, nil, nil],
      ["ABILIFY 30 MG TABLET", "59148001135", 40.98323, "Thu, 01 Jan 2015 00:00:00 +0000", "EA", "C/I", "N", "2", "B", nil, nil, nil],
      ["ABILIFY 5 MG TABLET", "59148000713", 28.72221, "Thu, 01 Jan 2015 00:00:00 +0000", "EA", "C/I", "N", "2", "B", nil, nil, nil],
      ["ABILIFY 5 MG TABLET", "59148000735", 28.72221, "Thu, 01 Jan 2015 00:00:00 +0000", "EA", "C/I", "N", "2", "B", nil, nil, nil]
    ]
  end

  describe "parsing results" do

    it "should get the correct number of results, skipping header rows, and write to the service cache" do 
      expect{ 
        NadacService.parse_worksheet(@worksheet_data) 
      }.to change{ServiceCache.count}.by(27)
    end

    it "should correctly parse results" do 
      NadacService.parse_worksheet(@worksheet_data)
      expect( NadacService.where_key_value('ndc','00113005452').count ).to eq 1
      expect( NadacService.where_key_value('ndc','59148000735').count ).to eq 1
      expect( NadacService.where_key_value('ndc_description','ABACAVIR 300 MG TABLET').count ).to eq 8
      expect( NadacService.where_key_value('ndc_description','ABACAVIR 300 MG TABLET').count ).to eq 8
      expect( NadacService.where_key_value('nadac_per_unit','29.03899').count ).to eq 2
      
    end

  end # parsing results

  describe "finding data" do 

    it "should find distinct pricing records based on brand name" do 
      NadacService.parse_worksheet(@worksheet_data)
      expect( NadacService.pricing_per_brand_name('abilify').length ).to eq 7
    end

  end

end
