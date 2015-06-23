json.meta do
  json.result_count @events.count
end
json.results do
  json.array!(@events) do |event|
    json.receivedate event['receivedate']
    json.serious event['serious']
    json.reportduplicate event['reportduplicate']
    json.primarysource do 
      json.qualification event['primarysource']['qualification'] if event['primarysource']
    end
    if event['patient']
      json.patient do 
        json.patientsex event['patient']['patientsex']
        json.patientweight event['patient']['patientweight']
        json.patientonsetage event['patient']['patientonsetage']
        json.patientonsetageunit event['patient']['patientonsetageunit']
        if event['patient']['reaction']
          json.reaction do 
            json.array! event['patient']['reaction'] do |reaction|
              json.reactionmeddrapt reaction['reactionmeddrapt']
            end
          end
        end
        if event['patient']['drug']
          json.drug do 
            json.array! event['patient']['drug'] do |drug|
              json.medicinalproduct drug['medicinalproduct']
              json.drugcharacterization drug['drugcharacterization']
            end
          end
        end
      end # patient
    end # if patient
  end
end