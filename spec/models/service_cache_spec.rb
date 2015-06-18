require 'spec_helper'

class TestService < ServiceCache
end

RSpec.describe ServiceCache do

  describe "saving" do

    it "should save a record" do 
      expect{
        TestService.write_cache "apple", {name: 'apple', color:'red', size:'medium'}
      }.to change{ServiceCache.count}.by 1
    end

    it "should assign the class name as the service name" do 
      expect(ServiceCache.where(:service => "TestService").count).to eq 0
      TestService.write_cache "apple", {name: 'apple', color:'red', size:'medium'}
      expect(ServiceCache.where(:service => "TestService").count).to eq 1
    end

    it "should update a duplicate record, simply updating attributes" do 
      expect{
        TestService.write_cache "apple", {name: 'apple', color:'red', size:'medium'}
        TestService.write_cache "apple", {name: 'apple', color:'reddish', size:'medium'}
      }.to change{ServiceCache.count}.by 1
      expect( TestService.find("apple")['color'] ).to eq 'reddish'
    end

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
