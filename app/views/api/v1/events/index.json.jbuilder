json.meta do
  json.partial! 'api/v1/shared/common_meta' 
  json.result_count @event_details.count
end
json.results do
  json.event_details do 
    json.array!(@event_details) do |event|
      json.receivedate event['receivedate']
      json.serious event['serious']
      json.reportduplicate event['reportduplicate']
      json.primarysource do 
        json.qualification event['primarysource']['qualification'] if event['primarysource']
      end
      if event['patient']
        json.patient do # TODO -> Extract partials
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
  end # event details
  json.age_breakdown do 
    json.array!(@age_breakdown) do |row|
      json.extract! row, :age_min, :age_max, :data
    end
  end
end