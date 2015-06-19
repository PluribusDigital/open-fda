class FdaEventService
  # DOCS    https://open.fda.gov/drug/event/reference/

  include HTTParty
  base_uri 'https://api.fda.gov/'

  def self.base_path
    '/drug/event.json'
  end

  def self.search(q)
    url = base_path + "?limit=10&search=" + q.to_s
    url = URI::encode(url)
    self.get(url)
  end

  def self.search_product_ndc(ndc)
    self.search 'patient.drug.openfda.product_ndc:"' + ndc + '"'
  end

  def self.event_count_by_reaction(brand_name, from_date=2.years.ago)
    from = from_date.strftime("%Y%m%d")
    to   = Time.now.strftime("%Y%m%d")
    self.search "receivedate:[#{from}+TO+#{to}]+AND+patient.drug.openfda.brand_name:\"#{brand_name}\"&count=patient.reaction.reactionmeddrapt.exact"
  end

end