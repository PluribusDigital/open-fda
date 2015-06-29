module API::V1
  class EventsController < ApplicationController

    def index
      if params[:brand_name] && params[:term]
        @event_details = FdaEventService.
          search_brand_term(params[:brand_name].to_s, params[:term].to_s)
      else
        @error = { code: "INVALID_PARAMETERS", message: "You must supply a product_ndc or brand_name parameter." }
      end
      @error = { code: "NOT_FOUND", message: "No matches found!" } unless @event_details
      render template:'api/v1/shared/error' if @error
    end

  end
end
