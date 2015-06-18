module API::V1
  class EventsController < ApplicationController
    
    def index
      @events = FdaEventService.search_product_ndc(params[:product_ndc].to_s) 
      render json: @events
    end

  end
end