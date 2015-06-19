json.meta "sample meta"
json.results do
  json.array!(@drugs) do |drug|
    json.extract! drug, :product_ndc, :proprietary_name, :nonproprietary_name
  end
end