# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Core product list
if Drug.count == 0 
	puts 'Bulk Load - Product NDC'
	CSV.foreach('data/product_ndc.txt', :col_sep => "\t",:headers => true, ) do |row|
		row = row.to_hash.delete_if{|k,v|k.blank?}
		Drug.create(row)
	end
end

if Substance.count == 0
	puts 'Bulk Load - Substances'
	CSV.foreach('data/openfda-substance_name.txt', :col_sep => "\t",:headers => true, ) do |row|
		row = row.to_hash.delete_if{|k,v|k.blank?}
		Substance.create(row)
	end
end

if Manufacturer.count == 0 
	puts 'Bulk Load - Manufacturers'
	CSV.foreach('data/openfda-manufacturer_name.txt', :col_sep => "\t",:headers => true, ) do |row|
		row = row.to_hash.delete_if{|k,v|k.blank?}
		Manufacturer.create(row)
	end
end

if PharmaClassChemical.count == 0 
	puts 'Bulk Load - Pharma Class (Chemical Structure)'
	CSV.foreach('data/openfda-pharm_class_cs.txt', :col_sep => "\t",:headers => true, ) do |row|
		row = row.to_hash.delete_if{|k,v|k.blank?}
		PharmaClassChemical.create(row)
	end
end

if PharmaClassEstablished.count == 0 
	puts 'Bulk Load - Pharma Class (Established Pharma Class)'
	CSV.foreach('data/openfda-pharm_class_epc.txt', :col_sep => "\t",:headers => true, ) do |row|
		row = row.to_hash.delete_if{|k,v|k.blank?}
		PharmaClassEstablished.create(row)
	end
end

if PharmaClassMethod.count == 0
	puts 'Bulk Load - Pharma Class (Method of Action)'
	CSV.foreach('data/openfda-pharm_class_moa.txt', :col_sep => "\t",:headers => true, ) do |row|
		row = row.to_hash.delete_if{|k,v|k.blank?}
		PharmaClassMethod.create(row)
	end
end

if PharmaClassPhysiologic.count == 0 
	puts 'Bulk Load - Pharma Class (Physiologic Effect)'
	CSV.foreach('data/openfda-pharm_class_pe.txt', :col_sep => "\t",:headers => true, ) do |row|
		row = row.to_hash.delete_if{|k,v|k.blank?}
		PharmaClassPhysiologic.create(row)
	end
end

if ProductType.count == 0
	puts 'Bulk Load - Product Type'
	CSV.foreach('data/openfda-product_type.txt', :col_sep => "\t",:headers => true, ) do |row|
		row = row.to_hash.delete_if{|k,v|k.blank?}
		ProductType.create(row)
	end
end

if Route.count == 0
	puts 'Bulk Load - Route'
	CSV.foreach('data/openfda-route.txt', :col_sep => "\t",:headers => true, ) do |row|
		row = row.to_hash.delete_if{|k,v|k.blank?}
		Route.create(row)
	end
end

if ServiceCache.count == 0 
	# Pricing data
	NadacService.read_workbook

	# Medication Guide links & data 
	FdaMedicationGuideService.import_data

	# Shortage/Discontinuation data
	FdaShortageService.import_data
end