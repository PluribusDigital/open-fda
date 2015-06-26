module Requests

  module JsonHelpers
    def json
      @json ||= JSON.parse(response.body)
    end
  end

  module DrugHelpers # TODO move to fixture or factory
    def setup_drug_data
      @prozac  = Drug.create(is_canon:true, proprietary_name:'Prozac',  product_ndc:'16590-843', nonproprietary_name:'gen1')
      @viagra  = Drug.create(is_canon:true, proprietary_name:'Viagra',  product_ndc:'0069-4200', nonproprietary_name:'SILDENAFIL CITRATE')
      @cialis  = Drug.create(is_canon:true, proprietary_name:'Cialis',  product_ndc:'0002-4464', nonproprietary_name:'gen3')
      @advilpm = Drug.create(is_canon:true, proprietary_name:'Revatio', product_ndc:'0069-4190', nonproprietary_name:'Sildenafil Citrate')
      @advilpm = Drug.create(is_canon:true, proprietary_name:'ADVIL PM', product_ndc:'0573-0164', nonproprietary_name:'Diphenhydramine Citrate and Ibuprofen')
      PharmaClassChemical.create(class_name:'abc CH',product_ndc:'0069-4200')
      PharmaClassEstablished.create(class_name:'abc EST',product_ndc:'0002-4464')
      PharmaClassEstablished.create(class_name:'abc EST',product_ndc:'0069-4200')
      PharmaClassMethod.create(class_name:'abc MTH',product_ndc:'0069-4200')
      PharmaClassPhysiologic.create(class_name:'abc PH',product_ndc:'0069-4200')
      Substance.create(name:'flubber',product_ndc:@prozac.product_ndc)
      Substance.create(name:'flubber',product_ndc:@viagra.product_ndc)
      Manufacturer.create(name:'ronco',product_ndc:@prozac.product_ndc)
      Manufacturer.create(name:'ronco',product_ndc:@viagra.product_ndc)
    end
  end

end