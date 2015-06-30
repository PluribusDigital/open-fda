require 'spec_helper'

RSpec.describe Manufacturer do

  include Helpers::DrugHelpers

  before :each do 
    setup_drug_data
    @m1_d1 = Manufacturer.create(name:'RonCo',product_ndc:'16590-843')
    @m1_d2 = Manufacturer.create(name:'RonCo',product_ndc:'0069-4200')
    @m2_d1 = Manufacturer.create(name:'BobCo',product_ndc:'0069-4190')
  end

  describe "finding related drugs" do 

    it "should find drugs when there is a matching set" do 
      expect( @m1_d1.drugs.length ).to eq 2
      expect( @m2_d1.drugs.length ).to eq 1
    end

  end

end
