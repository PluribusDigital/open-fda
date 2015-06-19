module API::V1
  class DrugsController < ApplicationController
    
    def index
      q = params[:q] || ""
      clause = 'lower(proprietary_name) LIKE ?',"%#{q.downcase}%"
      @drugs = q.present? ? Drug.select('DISTINCT ON (proprietary_name) product_ndc, proprietary_name, nonproprietary_name')
        .where(clause).limit(100) : []
    end

    def show
      drug = FdaLabelService.find_by_product_ndc params[:id] 
      # Return error code if drug not found
      return render json: {"error"=>{"code"=>"NOT_FOUND", "message"=>"No matches found!"}} unless drug
      brand_name = drug["openfda"]["brand_name"][0]
      generic_name = drug["openfda"]["generic_name"][0]
      # Layer on pricing data
      drug["nadac"] = NadacService.pricing_per_brand_name(brand_name)
      # Layer on events data
      drug["event_data"] = FdaEventService.event_count_by_reaction(brand_name)['results']
      drug["generics_list"] = Drug.where(nonproprietary_name: generic_name).map{|e|e.proprietary_name}.uniq.delete_if{|e|e==brand_name}
      render json: drug
    end 

  end
end