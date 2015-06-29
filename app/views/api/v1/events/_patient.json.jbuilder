json.patientsex patient['patientsex']
json.patientweight patient['patientweight']
json.patientonsetage patient['patientonsetage']
json.patientonsetageunit patient['patientonsetageunit']
if patient['reaction']
  json.reaction do 
    json.array! patient['reaction'] do |reaction|
      json.reactionmeddrapt reaction['reactionmeddrapt']
    end
  end
end
if patient['drug']
  json.drug do 
    json.array! patient['drug'] do |drug|
      json.medicinalproduct drug['medicinalproduct']
      json.drugcharacterization drug['drugcharacterization']
    end
  end
end