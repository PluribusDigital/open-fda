class FdaEventService < FdaService
  # DOCS    https://open.fda.gov/drug/event/reference/

  def self.base_path
    '/drug/event.json'
  end

  def self.search_product_ndc(ndc)
    ndc = normalize_product_ndc(ndc)
    search_serious 'patient.drug.openfda.product_ndc:"' + ndc + '"'
  end

  def self.search_brand_term(brand_name,term='')
    search_serious "patient.drug.openfda.brand_name:\"#{brand_name}\"+AND+patient.reaction.reactionmeddrapt:\"#{term}\""
  end

  def self.event_count_by_reaction(brand_name, from_date=2.years.ago)
    from = from_date.strftime("%Y%m%d")
    to   = Time.now.strftime("%Y%m%d")
    search_serious "receivedate:[#{from}+TO+#{to}]+AND+patient.drug.openfda.brand_name:\"#{brand_name}\"&count=patient.reaction.reactionmeddrapt.exact"
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