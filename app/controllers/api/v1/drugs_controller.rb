module API::V1
  class DrugsController < ApplicationController
    
    def index
      # cleanse the query parameter value
      q = params[:q] || ""
      # perform the search
      @drugs = Drug.typeahead_search(q)
    end

    def show
      # find the drug
      drug  = Drug.canonical.find_by_product_ndc(params[:id])
      # return error code if drug not found
      unless drug  
        return render json: {"error"=>{"code"=>"NOT_FOUND", "message"=>"No matches found!"}} 
      end
      # build up the object to be served, starting with core drug attributes
      drug_object = drug.core_attributes
      drug_object[:label] = FdaLabelService.find_by_product_ndc(drug.product_ndc)
      drug_object[:nadac] = NadacService.pricing_per_brand_name(drug.proprietary_name)
      drug_object[:event_data] = FdaEventService.event_count_by_reaction(drug.proprietary_name)['results']
      drug_object[:generics_list] = drug.generics
      drug_object[:pharma_classes] = drug.pharma_classes
      drug_object[:recall_list] = FdaEnforcementService.search_product_ndc(drug.product_ndc)
      drug_object[:medication_guide] = FdaMedicationGuideService.find(drug.proprietary_name) || {}
      drug_object[:shortages] = FdaShortageService.search_by_generic_name(drug.nonproprietary_name) || []
      drug_object[:routes] = drug.unique_routes
      return render json:drug_object
    end 

  end
end