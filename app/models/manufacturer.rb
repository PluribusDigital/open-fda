class Manufacturer < ActiveRecord::Base
  belongs_to :drug, foreign_key: 'product_ndc', primary_key: 'product_ndc'
end
