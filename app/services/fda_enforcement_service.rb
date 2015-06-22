class FdaEnforcementService < FdaService
  # DOCS    https://open.fda.gov/drug/enforcement/reference/

  def self.base_path
    '/drug/enforcement.json'
  end

  def self.search_product_ndc(ndc)
    ndc = normalize_product_ndc(ndc)
    pluck_result self.search 'openfda.product_ndc:"' + ndc + '"'
  end

end