json.partial! 'api/v1/node/drug', drug:@drug
json.children do
  json.array! %w(Generic Classes Substances Manufacturers) do |n|
    case n 
    when "Generic"
      json.name n
      json.children do 
        json.array! @drug.generics do |g|
          json.partial! 'api/v1/node/drug', drug:g
        end
      end
    when "Classes"
      json.name n
      json.children do 
        json.array! @drug.pharma_classes.select{|pc|pc[:type]=="establisheds"} do |pc|
          json.name pc[:class_name]
          json.type "Class"
            json.children do 
              json.array! pc[:drugs] do |pcd|
                json.partial! 'api/v1/node/drug', drug:pcd
              end
            end
        end
      end
    when "Substances"
      json.name n
      json.children do 
        json.array! @drug.unique_substances do |sub|
          json.name sub
          json.type "Substance"
          json.drillable "true"
          json.identifier sub
        end
      end
    when "Manufacturers"
      json.name n
      json.children do 
        json.array! @drug.unique_manufacturers do |mfr|
          json.name mfr
          json.drillable "true"
          json.identifier mfr
          json.type "Manufacturer"
        end
      end
    end 
  end
end