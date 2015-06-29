class FdaService < ServiceCache
  # Base Class to DRY up FDA service classes

  include HTTParty
  base_uri 'https://api.fda.gov/'

  def self.cache_timeframe
    1.day
  end
  
  def self.search(q,limit=10)
    url = URI::encode( base_path + "?api_key=#{api_key}&limit=#{limit}&search=" + q.to_s )
    # Does an existing cache match the URL? If so, use that, else do a live API call
    return cache_exists?(url) ? find(url) : live_search(url)
  end

  def self.live_search(url)
    result = self.get url
    raise "API Rate Limit Exceeded" if result['error'] && result['error']['code'] == 'OVER_RATE_LIMIT'
    write_cache url, result
    return result
  end

private 

  def self.api_key 
    ENV['OPENFDA_API_KEY']
  end

  def self.normalize_product_ndc(ndc)
    # split on hyphen
    # if first half length = 5
    #   and 2nd half < 1000 (when leading zeros trimmed/numberfied)
    # then normalize to zero padded 3 digits (i.e. xxxxx-0006 becomes xxxxx-006)
    labeler, product_code = ndc.split("-")
    if labeler.length == 5 && product_code.to_i < 1000
      return labeler + "-" + product_code.to_i.to_s.rjust(3,'0') # rjust does zero pad to 3 digits
    else
      return ndc
    end
  end

  def self.pluck_result(search_result)
    return search_result["results"] || []
  end

end
