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
    ndc = clean_product_ndc(ndc)
    result = self.search('product_ndc:"' + ndc + '"')
    return result["results"].present? ? result["results"].first : nil
  end

private

  def self.clean_product_ndc(ndc)
    # split on hyphen
    # if first half length = 5
    #   and 2nd half < 1000 (when leading zeros trimmed/numberfied)
    # then remove one leading zero (i.e. xxxxx-0006 becomes xxxxx-006)
    labeler, product_code = ndc.split("-")
    if labeler.length == 5 && product_code.to_i < 1000
      return labeler + "-" + product_code[1..3]
    else
      return ndc
    end
  end

end