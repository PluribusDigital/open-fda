json.meta "sample meta"
json.results do
  json.array!(@drugs) do |drug|
    json.extract! drug, :id, :name
  end
end