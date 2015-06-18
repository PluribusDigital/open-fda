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

end