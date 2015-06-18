json.meta "sample meta"
json.results do
  json.array!(@drugs) do |drug|
    json.extract! drug, :product_ndc, :name
  end
end