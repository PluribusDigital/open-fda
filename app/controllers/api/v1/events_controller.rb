module API::V1
  class EventsController < ApplicationController
    
    def index
      # TODO refactor to make gooder :)
      if params[:product_ndc]
        @events = FdaEventService.search_product_ndc(params[:product_ndc].to_s) 
      elsif params[:brand_name] && params[:term]
        @events = FdaEventService.search_brand_term(params[:brand_name].to_s, params[:term].to_s) 
      end
      render json: @events
    end

  end
end