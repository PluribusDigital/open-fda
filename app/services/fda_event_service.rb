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
    search_serious "#{query_date_range}+AND+patient.drug.openfda.brand_name:\"#{brand_name}\"+AND+patient.reaction.reactionmeddrapt:\"#{term}\""
  end

  def self.age_breakdown_brand_term(brand_name,term='')
    result = []
    age_ranges = [
      [0,17.9],
      [18,55]
    ]
    age_ranges.each do |range|
      base_string = "#{query_date_range}+AND+patient.drug.openfda.brand_name:\"#{brand_name}\"+AND+patient.reaction.reactionmeddrapt:\"#{term}\""
      age_string  ="+AND+patient.patientonsetage:[#{range[0].to_s}+TO+#{range[1].to_s}]&count=patient.patientsex"
      result << {
        age_min: range[0],
        age_max: range[1],
        data: search_serious(base_string+age_string)
      }
    end
    return result
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

end