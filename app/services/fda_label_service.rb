class FdaLabelService 
  # DOCS    https://open.fda.gov/drug/label/reference/

  include HTTParty
  base_uri 'https://api.fda.gov/'

  def self.base_path
    '/drug/label.json'
  end

  def self.search(q)
    url = base_path + "?limit=10&search=" + q.to_s
    url = URI::encode(url)
    self.get(url)
  end

  def self.find_by_product_ndc(ndc)
    result = self.search('product_ndc:"' + ndc + '"')
    return result["results"].present? ? result["results"].first : nil
  end

end