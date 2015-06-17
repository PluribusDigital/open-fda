class LabelService 
  # DOCS    https://open.fda.gov/drug/label/reference/

  include HTTParty
  base_uri 'https://api.fda.gov/'

  def self.base_path
    '/drug/label.json'
  end

  def self.name_search(q)
    url = base_path + "?limit=10&search=" + q.to_s
    self.get(url)['results']
  end

  def self.product_ndc_search(ndc)
    url = base_path + '?limit=10&search=product_ndc:"' + ndc + '"'
    url = URI::encode(url)
    self.get(url)['results'].first
  end

end