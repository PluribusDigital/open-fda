json.name @manufacturer.name
json.type "Manufacturer"
json.drillable "true"
json.identifier @manufacturer.name
json.children do 
  json.array! @manufacturer.drugs do |drug|
    json.partial! 'api/v1/node/drug', drug:drug
  end
end