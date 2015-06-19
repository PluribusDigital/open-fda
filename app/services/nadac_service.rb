class NadacService < ServiceCache
  # DOCS http://www.medicaid.gov/Medicaid-CHIP-Program-Information/By-Topics/Benefits/Prescription-Drugs/Pharmacy-Pricing.html
  # DATA (first file in zip from first link on above page)
  # Note: Key value is package_ndc

  def self.read_workbook
    puts "reading workbook "
    workbook = RubyXL::Parser.parse(data_file)
    parse_worksheet workbook['NADAC'].extract_data
    puts "Victory is Ours!"
  end

  def self.parse_worksheet(worksheet)
    consecutive_nil_rows = 0
    header_row = worksheet[3].select{|e|e.present?}.map{|e|e.parameterize.underscore}
    row_index = 4 
    while consecutive_nil_rows < 10 do 
      row         = worksheet[row_index]
      ndc         = row[1].to_s if row 
      is_data_row = row && ndc && ndc.present?
      if is_data_row
        data = Hash[ header_row.zip row ]
        write_cache ndc , data 
        consecutive_nil_rows=0
      else
        consecutive_nil_rows+=1
      end
      row_index +=1
    end
    return true
  end

  def self.pricing_per_ndc_list(package_ndc_list)
    result = []
    package_ndc_list.each do |package_ndc|
      nadac = self.find(package_ndc)
      result << {
        package_ndc:package_ndc, 
        nadac_per_unit:nadac.nadac_per_unit , 
        pricing_unit:nadac.pricing_unit
      } if nadac
    end
    return result
  end

  def self.pricing_per_brand_name(brand_name)
    self.where_key_value_like("ndc_description", brand_name).map{|e|e[:data]}
  end

private

  def self.data_file
    'data/NADAC 20150617.xlsx'
  end

end