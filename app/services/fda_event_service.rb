class FdaEventService < FdaService
  # DOCS    https://open.fda.gov/drug/event/reference/

  def self.base_path
    '/drug/event.json'
  end

  def self.search_product_ndc(ndc)
    ndc = normalize_product_ndc(ndc)
    self.search 'patient.drug.openfda.product_ndc:"' + ndc + '"'
  end

  def self.event_count_by_reaction(brand_name, from_date=2.years.ago)
    from = from_date.strftime("%Y%m%d")
    to   = Time.now.strftime("%Y%m%d")
    self.search "receivedate:[#{from}+TO+#{to}]+AND+patient.drug.openfda.brand_name:\"#{brand_name}\"&count=patient.reaction.reactionmeddrapt.exact"
  end

end