json.name @substance.name
json.type "Substance"
json.drillable "true"
json.identifier @substance.name
json.children do 
  json.array! @drugs do |drug|
    json.partial! 'api/v1/node/drug', drug:drug
  end
end