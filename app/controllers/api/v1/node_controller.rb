module API::V1
  class NodeController < ApplicationController

    def drug
      @drug  = Drug.canonical.find_by_product_ndc(params[:product_ndc])
    end

    def manufacturer
      @manufacturer = Manufacturer.find_by_name(params[:manufacturer_name])
      @drugs = Drug.canonical
        .joins( :manufacturers )
        .where( 'manufacturers.name' => @manufacturer.name )
    end

    def substance
      @substance = Substance.find_by_name(params[:substance_name])
      @drugs = Drug.canonical
        .joins( :substances )
        .where( 'substances.name' => @substance.name )
    end

  end
end

