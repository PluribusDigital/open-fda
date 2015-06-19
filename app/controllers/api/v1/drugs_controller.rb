module API::V1
  class DrugsController < ApplicationController
    
    def index
      q = params[:q] || ""
      @drugs = [
        {name: 'Prozac',    product_ndc: '16590-843'},
        {name: 'Viagra',    product_ndc: '55289-524'},
        {name: 'Atripla',   product_ndc: '24236-292'}
      ]
      @drugs = q.present? ? @drugs.select{|d|d[:name].downcase.include? q.downcase} : []
    end

    def show
      drug = FdaLabelService.find_by_product_ndc params[:id] 
      # Return error code if drug not found
      return render json: {"error"=>{"code"=>"NOT_FOUND", "message"=>"No matches found!"}} unless drug
      brand_name = drug["openfda"]["brand_name"][0]
      # Layer on pricing data
      drug["nadac"] = NadacService.pricing_per_brand_name(brand_name)
      # Layer on events data
      drug["event_data"] = FdaEventService.event_count_by_reaction(brand_name)['results']
      render json: drug
    end 

  end
end