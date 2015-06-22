class Drug < ActiveRecord::Base
  has_many :manufacturers,             foreign_key: 'product_ndc', primary_key: 'product_ndc'
  has_many :pharma_class_chemicals,    foreign_key: 'product_ndc', primary_key: 'product_ndc'
  has_many :pharma_class_establisheds, foreign_key: 'product_ndc', primary_key: 'product_ndc'
  has_many :pharma_class_methods,      foreign_key: 'product_ndc', primary_key: 'product_ndc'
  has_many :pharma_class_physiologics, foreign_key: 'product_ndc', primary_key: 'product_ndc'
  has_many :product_types,             foreign_key: 'product_ndc', primary_key: 'product_ndc'
  has_many :substances,                foreign_key: 'product_ndc', primary_key: 'product_ndc'
  
end
