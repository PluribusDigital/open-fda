class FdaEventService < FdaService
  # DOCS    https://open.fda.gov/drug/event/reference/

  def self.base_path
    '/drug/event.json'
  end

  # TODO Delete?
  # def self.search_product_ndc(ndc)
  #   ndc = normalize_product_ndc(ndc)
  #   search_serious 'patient.drug.openfda.product_ndc:"' + ndc + '"'
  # end

  def self.search_brand_term(brand_name,term='')
    result = search_serious "#{query_date_range}+AND+patient.drug.openfda.brand_name:\"#{brand_name}\"+AND+patient.reaction.reactionmeddrapt:\"#{term}\""
    result["age_breakdown"] = event_age_calcs(result)
    result["qualification_breakdown"] = event_qualification_calcs(result)
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

  def self.search_serious(additional_query_string)
    # find events where a given drug is a suspect in a serious outcome
    search_phrases = [
      "serious:1",
      "_missing_:reportduplicate",
      additional_query_string
    ] 
    self.search search_phrases.join("+AND+")
  end

  private

  def self.event_age_calcs(events)
    # initialize hashes
    h = Hash.new{|h,k| h[k]=[]}
    group_event_by_gender_and_age = Hash.new

    # pull out events with gender and ages e.g., [ {1 => 65}, {2 => 18} ...]
    arr = events["results"].map {|e| Hash[e["patient"]["patientsex"],e["patient"]["patientonsetage"].to_i]}
    # group event patientonsetage by sex
    arr.map(&:to_a).flatten(1).each{|v| h[v[0]] << v[1]}
    # set age bins
    age_ranges = [
      0..17.9,
      18..59.9,
      60..110
    ]
    # group all ages by gender then age group
    ["1", "2"].each do |sex|
      group_event_by_gender_and_age[sex] = h[sex].group_by { |v| age_ranges.find { |r| r.cover? v } }
    end
    return group_event_by_gender_and_age
  end

  def self.event_qualification_calcs(events)
    # 1 = Physician
    # 2 = Pharmacist
    # 3 = Other Health Professional
    # 4 = Lawyer
    # 5 = Consumer or non-health professional
    qualification = Hash.new(-1)
    events["results"].each do |event|
      qualification[event["primarysource"]["qualification"]] += 1
    end
    return qualification
  end





end
