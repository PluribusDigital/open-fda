module API::V1

  class NodeController < ApplicationController
    include ApplicationHelper
    
    def drug
      @drug  = Drug.canonical.find_by_product_ndc(params[:product_ndc])
      @error = { code: "NOT_FOUND", message: "No matches found!" } unless @drug
      render template:'api/v1/shared/error' if @error
    end

    def manufacturer
      name = unescape_periods(params[:manufacturer_name])
      @manufacturer = Manufacturer.find_by_name(name)
      @error = { code: "NOT_FOUND", message: "No matches found!" } unless @manufacturer
      render template:'api/v1/shared/error' if @error
    end

    def substance
      name = unescape_periods(params[:substance_name])
      @substance = Substance.find_by_name(name)
      @error = { code: "NOT_FOUND", message: "No matches found!" } unless @substance
      render template:'api/v1/shared/error' if @error
    end  

  end

end

