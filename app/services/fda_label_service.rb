class FdaLabelService < FdaService
  # DOCS    https://open.fda.gov/drug/label/reference/

  def self.base_path
    '/drug/label.json'
  end

  def self.find_by_product_ndc(ndc)
    ndc = normalize_product_ndc(ndc)
    result = self.search('openfda.product_ndc:"' + ndc + '"')
    return result["results"].present? ? result["results"].first : nil
  end

  def self.search_by_class(pharm_class)
    return streamline_results self.search('openfda.pharm_class_epc:"' + pharm_class + '"')
  end

private
  
  def self.streamline_results(search_result)
    # maps the returned data to a subset of fields, 
    # so that unused data isn't passed around
    fields_to_keep = %w(product_ndc substance_name manufacturer_name brand_name route pharm_class_epc product_ndc package_ndc generic_name) 
    pluck_result(search_result)
        .map{ |r| r['openfda'].delete_if{|key,v| !fields_to_keep.include? key} }
        .uniq{ |i| i['brand_name'] }
  end

end