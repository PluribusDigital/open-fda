json.meta do
  json.partial! 'api/v1/shared/common_meta' 
  json.result_count @drug_result[:results].count
end
json.extract! @drug_result, :results