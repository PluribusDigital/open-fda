class Substance < ActiveRecord::Base
  
  def canonical_drugs
    Drug.canonical
        .joins( :substances )
        .where( 'substances.name' => self.name )
        .order( 'drugs.proprietary_name' )
  end

end
