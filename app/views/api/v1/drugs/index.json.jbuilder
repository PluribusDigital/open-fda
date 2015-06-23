json.meta do
  json.result_count @drugs.count
end
json.results do
  json.array!(@drugs) do |drug|
    json.extract! drug, :product_ndc, :proprietary_name, :nonproprietary_name
  end
end