# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Core product list
CSV.foreach('data/product_ndc.txt', :col_sep => "\t",:headers => true, ) do |row|
  row = row.to_hash.delete_if{|k,v|k.blank?}
	Drug.create(row)
end

# Pricing data
NadacService.read_workbook

# Medication Guide links & data 
FdaMedicationGuideService.import_data