class FdaLabelService < FdaService
  # DOCS    https://open.fda.gov/drug/label/reference/

  def self.base_path
    '/drug/label.json'
  end

  def self.find_by_product_ndc(ndc)
    ndc = normalize_product_ndc(ndc)
    result = self.search('openfda.product_ndc:"' + ndc + '"')
    return result["results"].present? ? streamline(result["results"].first) : nil
  end

private 

  def self.streamline(label)
    keep_keys = %w(indications_and_usage stop_use drug_interactions pediatric_use pregnancy)
    return label = label.keep_if{|key,v| keep_keys.include? key }
  end

end
