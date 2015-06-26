module API::V1
  class NodeController < ApplicationController

    def drug
      drug  = Drug.canonical.find_by_product_ndc(params[:id])
      node_object = {
        name: drug.proprietary_name,
        type: "Drug",
        drillable: "true",
        children: []
      }
      node_object[:children] << {
        name: "Generic",
        children: [
          {
            name: drug.nonproprietary_name, 
            children: drug.node_generics.map{|g|g.merge({type:"Drug",drillable:"true"})},
            type: "Generic" 
          }
        ]
      }
      node_object[:children] << {
        name: "Classes",
        type: "",
        children: drug.pharma_classes
          .select{|pc|pc[:type]=="establisheds"}.map{|pc|
          {
            name: pc[:class_name],
            type: "Class",
            children: pc[:drugs].map{|d|
              {
                name: d[:proprietary_name],
                type: "Drug",
                product_ndc: d[:product_ndc],
                drillable: "true"
              }
            }
          }
        }
      }
      
      node_object[:children] << {
        name: "Substances",
        type: "",
        children: drug.unique_substances.map{|s|
          {
            name: s,
            type: ""
          }
        }
      }
      node_object[:children] << {
        name: "Manufacturers",
        type: "",
        children: drug.unique_manufacturers.map{|m|
          {
            name: m,
            type: ""
          }
        }
      }

      return render json:node_object
    end

    # def manufacturer
    # end

    # def substance
    # end

  end
end

