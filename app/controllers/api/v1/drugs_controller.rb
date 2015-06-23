module API::V1
  class DrugsController < ApplicationController
    
    def index
      q = params[:q] || ""
      clause = 'lower(proprietary_name) LIKE ?',"%#{q.downcase}%"
      @drugs = q.present? ? Drug.select('DISTINCT ON (proprietary_name) product_ndc, proprietary_name, nonproprietary_name')
        .where(clause).limit(10) : []
    end

    def show
      # TODO - refactor to use Drug class method or concern or something
      drug = FdaLabelService.find_by_product_ndc params[:id] 
      # Return error code if drug not found
      return render json: {"error"=>{"code"=>"NOT_FOUND", "message"=>"No matches found!"}} unless drug
      brand_name   = drug["openfda"]["brand_name"]      ? drug["openfda"]["brand_name"][0]      : nil
      generic_name = drug["openfda"]["generic_name"]    ? drug["openfda"]["generic_name"][0]    : nil
      pharm_class  = drug["openfda"]["pharm_class_epc"] ? drug["openfda"]["pharm_class_epc"][0] : nil
      # Layer on pricing data
      drug["nadac"] = NadacService.pricing_per_brand_name(brand_name)
      # Layer on events data
      drug["event_data"] = FdaEventService.event_count_by_reaction(brand_name)['results']
      drug["generics_list"] = Drug.where('lower(nonproprietary_name) LIKE ?',"%#{generic_name.downcase}%")
        .map{|e|{proprietary_name:e.proprietary_name,product_ndc:e.product_ndc}}
        .uniq{|e|e[:proprietary_name]}
        .delete_if{|e|e[:proprietary_name]==brand_name}
      drug["same_class_list"] = pharm_class ? FdaLabelService.search_by_class(pharm_class)
        .delete_if{|e|e["brand_name"][0]==brand_name} : []
      drug["recall_list"] = FdaEnforcementService.search_product_ndc params[:id]
      drug["medication_guide"] = FdaMedicationGuideService.find(brand_name) || {}
      drug["shortages"] = FdaShortageService.search_by_generic_name(generic_name).map{|e|e.data} || []
      render json: drug
    end 

  end
end
