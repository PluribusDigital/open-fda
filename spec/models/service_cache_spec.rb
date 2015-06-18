require 'spec_helper'

class TestService < ServiceCache
end

RSpec.describe ServiceCache do

  describe "saving" do

    it "should save a record"

    it "should update a duplicate record"

  end

  describe "finding" do

    before :each do 
      TestService.write_cache "apple", {name: 'apple', color:'red', size:'medium'}
    end
    
    it "should find an existing record" do 
      expect( TestService.find("apple")['color'] ).to eq 'red'
    end

    it "should return an empty result for a non-match" do 
      expect( TestService.find("kumquat") ).to eq nil
    end

  end

end
