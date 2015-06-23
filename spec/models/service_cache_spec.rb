require 'spec_helper'

class FruitService < ServiceCache
end
class VeggieService < ServiceCache
end

RSpec.describe ServiceCache do

  describe "saving" do

    it "should save a record" do 
      expect{
        FruitService.write_cache "apple", {name: 'apple', color:'red', size:'medium'}
      }.to change{ServiceCache.count}.by 1
    end

    it "should assign the class name as the service name" do 
      expect(ServiceCache.where(:service => "FruitService").count).to eq 0
      FruitService.write_cache "apple", {name: 'apple', color:'red', size:'medium'}
      expect(ServiceCache.where(:service => "FruitService").count).to eq 1
    end

    it "should update a duplicate record, simply updating attributes" do 
      expect{
        FruitService.write_cache "apple", {name: 'apple', color:'red', size:'medium'}
        FruitService.write_cache "apple", {name: 'apple', color:'reddish', size:'medium'}
      }.to change{ServiceCache.count}.by 1
      expect( FruitService.find("apple")['color'] ).to eq 'reddish'
    end

  end # saving

  describe "finding and destroying" do

    before :each do 
      FruitService.write_cache  "apple",       {name: 'apple',       color:'red',      size:'medium'}
      FruitService.write_cache  "orange",      {name: 'orange',      color:'orange',   size:'medium'}
      FruitService.write_cache  "grape",       {name: 'grape',       color:'purple',   size:'small'}
      FruitService.write_cache  "watermelon",  {name: 'watermelon',  color:'redgreen', size:'large'}
      VeggieService.write_cache "pepper",      {name: 'pepper',      color:'green',    size:'medium'}
    end
    
    describe "single record based on key" do

      it "should find an existing record" do 
        expect( FruitService.find("apple")['color'] ).to eq 'red'
      end

      it "should return an empty result for a non-match" do 
        expect( FruitService.find("kumquat") ).to eq nil
      end

    end

    describe "multiple records based on query of data store" do

      it "should fetch records based on key-value" do 
        expect( FruitService.where_key_value('size','small').length ).to eq 1
      end

      it "should only fetch records based on key-value for this service" do 
        expect( FruitService.where_key_value('size','medium').length ).to eq 2
      end

      it "should match on substrings (case insensitive LIKE)" do 
        expect( FruitService.where_key_value_like('color','Red').length ).to eq 2 
      end

    end

    describe "destroying" do 

      it "should remove a record that exists" do 
        expect{
          FruitService.delete_cache('apple')
        }.to change{ServiceCache.count}.by(-1)
      end

      it "should raise an error for a record that doesn't exist" do 
        expect{
          FruitService.delete_cache('horse')
        }.to raise_error
      end

    end # destroying

  end # finding



end
