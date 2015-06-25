module API::V1
  class NodeController < ApplicationController

    def drug
      drug  = Drug.canonical.find_by_product_ndc(params[:id])
      node_object = {
        name: drug.proprietary_name,
        children: [
          {
            name: drug.nonproprietary_name, 
            children: drug.node_generics 
          }
        ]
      }
      return render json:node_object
    end

    # def manufacturer
    # end

    # def substance
    # end

  end
end

