require 'spec_helper'

RSpec.describe Drug do

  include Requests::DrugHelpers

  before :each do 
    setup_drug_data
  end

  describe "typeahead results" do 

    it "should find viagra" do 
      expect( Drug.typeahead_search("Viag").length ).to eq 1
    end

    it "should match on substring" do 
      expect( Drug.typeahead_search("ia").length ).to eq 2
    end

  end

  describe "finding cohorts" do 

    it "should find generics when there is a match" do 
      expect( @viagra.generics.length ).to eq 1
    end

    it "should NOT find generics when there is NO match" do 
      expect( @prozac.generics.length ).to eq 0
    end

    it "should find pharma class info" do 
      expect( @viagra.pharma_classes.length ).to eq 4
    end

    it "should find pharma class-mates, excluding self" do
      expect( @viagra.pharma_classes.select{|e|e[:type]=='establisheds'}[0][:drugs].length ).to eq 1
    end

  end

end
