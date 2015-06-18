module API::V1
  class DrugsController < ApplicationController
    
    def index
      @drugs = [
        {name: 'Prozac',    product_ndc: '16590-843'},
        {name: 'Viagra',    product_ndc: '55289-524'},
        {name: 'Atripla',   product_ndc: '24236-292'}
      ]
      if params[:name].present?
        @drugs = @drugs.select{|d|d[:name].include? params[:name]}
      end
    end

    def show
      drug = LabelService.product_ndc_search params[:id] 
      # Layer on pricing data
      drug["nadac"] = [] 
      drug["openfda"]["package_ndc"].each do |package_ndc|
        nadac = NadacService.find(package_ndc)
        drug["nadac"] << {
          package_ndc:package_ndc, 
          nadac_per_unit:nadac.nadac_per_unit , 
          pricing_unit:nadac.pricing_unit
        } if nadac
      end
      render json: drug
    end 

  end
end