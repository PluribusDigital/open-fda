class FdaEventService < FdaService
  # DOCS    https://open.fda.gov/drug/event/reference/

  def self.base_path
    '/drug/event.json'
  end

  def self.search_brand_term(brand_name,term='')
    result = search_serious "#{query_date_range}+AND+patient.drug.openfda.brand_name:\"#{brand_name}\"+AND+patient.reaction.reactionmeddrapt:\"#{term}\"", 99
    if result["results"]
      result["age_breakdown"] = event_age_calcs(result)
      result["qualification_breakdown"] = event_qualification_calcs(result)
    end
    return result
  end

  def self.source_qualification(brand_name,term='')
    search_string = "#{query_date_range}+AND+patient.drug.openfda.brand_name:\"#{brand_name}\"+AND+patient.reaction.reactionmeddrapt:\"#{term}\"&count=primarysource.qualification"
    search_serious(search_string)
  end

  def self.event_count_by_reaction(brand_name, from_date=2.years.ago)
    r = search_serious "#{query_date_range}+AND+patient.drug.openfda.brand_name:\"#{brand_name}\"&count=patient.reaction.reactionmeddrapt.exact"
    return r['results'] || []
  end

  def self.query_date_range(from_date=2.years.ago)
    from = from_date.strftime("%Y%m%d")
    to   = Time.now.strftime("%Y%m%d")
    return "receivedate:[#{from}+TO+#{to}]"
  end

  def self.search_serious(additional_query_string, limit = 10)
    # find events where a given drug is a suspect in a serious outcome
    search_phrases = [
      "serious:1",
      "_missing_:reportduplicate",
      additional_query_string
    ] 
    search_result = self.search(search_phrases.join("+AND+"),limit)
    search_result["results"].sort! { |x,y| y['receivedate'] <=> x['receivedate'] } if search_result["results"]
    return search_result
  end

  private

  def self.event_age_calcs(events)
    genders = { "1"=>:male, "2"=>:female, "0"=>:unknown }
    ageData = [
      {group: 'unknown',  male: 0,  female: 0, unknown: 0},
      {group: '1-18',     male: 0,  female: 0, unknown: 0},
      {group: '18-60',    male: 0,  female: 0, unknown: 0},
      {group: '60-100',   male: 0,  female: 0, unknown: 0}
    ]

    events["results"].each do |e|

      case e["patient"]["patientonsetage"].to_i
        when 0
          ageData.find { |el| el[:group]== 'unknown'}[genders[e["patient"]["patientsex"]]] += 1
        when 0...18
          ageData.find { |el| el[:group]== '1-18'}[genders[e["patient"]["patientsex"]]] += 1
        when 18..59
          ageData.find { |el| el[:group]== '18-60'}[genders[e["patient"]["patientsex"]]] +=1
        when 60..Float::INFINITY
          ageData.find { |el| el[:group]== '60-100'}[genders[e["patient"]["patientsex"]]] += 1
        else
          ageData.find { |el| el[:group]== 'unknown'}[genders[e["patient"]["patientsex"]]] += 1
      end
    end
    # group all ages by gender then age group
    return ageData
  end

  def self.event_qualification_calcs(events)
    quals = {
     0 => 'Unknown',
     1 => 'Physician',
     2 => 'Pharmacist',
     3 => 'Other Health Professional',
     4 => 'Lawyer',
     5 => 'Consumer or non-health professional',
    }
    qualification = Hash.new(0)
    events["results"].each do |event|
      qualification[quals[event["primarysource"]["qualification"].to_i].parameterize.underscore.to_sym] += 1
    end
    quals.each do |k,sym|
      qualification[sym.parameterize.underscore.to_sym] = qualification[sym.parameterize.underscore.to_sym] || 0
    end
    return qualification
  end

end
