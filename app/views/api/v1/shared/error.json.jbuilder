json.error do
  json.code    @error[:code]
  json.message @error[:message]
end