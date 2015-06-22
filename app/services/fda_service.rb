class FdaService
  # Base Class to DRY up FDA service classes

  include HTTParty
  base_uri 'https://api.fda.gov/'

  def self.search(q)
    url = base_path + "?limit=10&search=" + q.to_s
    url = URI::encode(url)
    self.get(url)
  end

private 

  def self.normalize_product_ndc(ndc)
    # split on hyphen
    # if first half length = 5
    #   and 2nd half < 1000 (when leading zeros trimmed/numberfied)
    # then normalize to zero padded 3 digits (i.e. xxxxx-0006 becomes xxxxx-006)
    labeler, product_code = ndc.split("-")
    if labeler.length == 5 && product_code.to_i < 1000
      return labeler + "-" + product_code.rjust(3,'0') # rjust does zero pad to 3 digits
    else
      return ndc
    end
  end

end