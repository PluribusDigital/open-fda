# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

CSV.foreach('data/product_ndc.txt', :col_sep => "\t",:headers => true, ) do |row|
  row = row.to_hash.delete_if{|k,v|k.blank?}
	Drug.create(row)
end