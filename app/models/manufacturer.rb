class Manufacturer < ActiveRecord::Base
  belongs_to :drug, foreign_key: 'product_ndc', primary_key: 'product_ndc'

  def drugs 
    Drug.joins( :manufacturers )
        .joins( :canonical_drug )
        .select( 'drugs.product_ndc', 'drugs.proprietary_name' )
        .where( 'manufacturers.name' => self.name )
        .where( 'canonical_drugs_drugs.is_canon' => true )
        .order( 'drugs.proprietary_name' )
        .distinct
  end

end
