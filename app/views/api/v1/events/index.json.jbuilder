json.meta do
  json.partial! 'api/v1/shared/common_meta' 
  json.result_count @event_details.count
end
json.results do
  json.event_details do 
    json.array!(@event_details["results"]) do |event|
      json.receivedate event['receivedate']
      json.serious event['serious']
      json.reportduplicate event['reportduplicate']
      json.primarysource do 
        json.qualification event['primarysource']['qualification'] if event['primarysource']
      end
      if event['patient']
        json.patient do 
          json.partial! 'api/v1/events/patient', patient:event['patient']
        end # patient
      end # if patient
    end 
  end # event details
  json.age_breakdown do
    if @event_details["age_breakdown"]
        json.array!(@event_details["age_breakdown"]) do |row|
         json.extract! row, :group, :male, :female, :unknown
        end
    end
  end
  json.qualification_breakdown do
    if @event_details["qualification_breakdown"]
      json.extract! @event_details["qualification_breakdown"],
        :unknown,
        :physician,
        :pharmacist,
        :other_health_professional,
        :lawyer,
        :consumer_or_non_health_professional
    end
  end
end
