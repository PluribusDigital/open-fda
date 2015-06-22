class Manufacturer < ActiveRecord::Base
  has_many :drugs, foreign_key: 'product_ndc', primary_key: 'product_ndc'
end
