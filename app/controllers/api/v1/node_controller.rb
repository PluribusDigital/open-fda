
module API::V1

  class NodeController < ApplicationController
    include ApplicationHelper
    
    def drug
      @drug  = Drug.canonical.find_by_product_ndc(params[:product_ndc])
    end

    def manufacturer
      name = unescape_trailing_period(params[:manufacturer_name])
      @manufacturer = Manufacturer.find_by_name(name)
    end

    def substance
      name = unescape_trailing_period(params[:substance_name])
      @substance = Substance.find_by_name(name)
    end  

  end

end

