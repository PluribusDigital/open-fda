class Drug < ActiveRecord::Base
  has_many :manufacturers,             foreign_key: 'product_ndc', primary_key: 'product_ndc'
  has_many :pharma_class_chemicals,    foreign_key: 'product_ndc', primary_key: 'product_ndc'
  has_many :pharma_class_establisheds, foreign_key: 'product_ndc', primary_key: 'product_ndc'
  has_many :pharma_class_methods,      foreign_key: 'product_ndc', primary_key: 'product_ndc'
  has_many :pharma_class_physiologics, foreign_key: 'product_ndc', primary_key: 'product_ndc'
  has_many :product_types,             foreign_key: 'product_ndc', primary_key: 'product_ndc'
  has_many :substances,                foreign_key: 'product_ndc', primary_key: 'product_ndc'  
  has_many :routes,                    foreign_key: 'product_ndc', primary_key: 'product_ndc'  

  def self.canonical
    self.where(is_canon:true)
  end

  def self.typeahead_search(q)
    select = 'DISTINCT ON (proprietary_name) product_ndc, proprietary_name, nonproprietary_name'
    clause = 'lower(proprietary_name) LIKE ?',"#{q.downcase}%"
    drugs_start_with = q.present? ? Drug.canonical.select(select).where(clause).limit(10) : []
    matched_names = drugs_start_with.map{|d|d.proprietary_name}
    clause = 'lower(proprietary_name) LIKE ?',"%#{q.downcase}%"
    drugs_like = q.present? ? Drug.canonical.select(select).where(clause).limit(10-matched_names.length) : []
    return drugs_start_with + drugs_like.select{|d|!matched_names.include? d.proprietary_name}
  end

  def core_attributes
    keep_keys = %w(product_ndc proprietary_name nonproprietary_name dea_schedule)
    attributes.keep_if{|key,v| keep_keys.include? key }
  end 

  def generics
    # grab other drugs w/ same generic (nonproprietary_name)
    # make it unique, and don't include yourself
    return [] unless nonproprietary_name
    Drug.canonical.where( 'lower(nonproprietary_name) LIKE ?' , "%#{nonproprietary_name.downcase}%" )
      .map{|e|{proprietary_name:e.proprietary_name,product_ndc:e.product_ndc}}
      .uniq{|e|e[:proprietary_name]}
      .delete_if{|e|e[:proprietary_name].downcase==proprietary_name.downcase}
  end

  def pharma_classes 
    pclasses = []
    class_types = %w(chemicals establisheds methods physiologics)
    class_types.each do |class_type|
      matches = self.send("pharma_class_#{class_type}")
      pclasses = pclasses + matches.map{|e| {type:class_type,class_name:e.class_name,drugs:e.drugs_in_class} }
    end
    return pclasses
  end

  def unique_routes
    routes.pluck(:route).uniq || []
  end

  def unique_substances
    substances.pluck(:name).uniq || []
  end

  def unique_manufacturers
    manufacturers.pluck(:name).uniq || []
  end

  def associated_ndcs
    Drug.includes(:manufacturers)
      .where(proprietary_name:proprietary_name)
      .order('product_ndc, package_ndc ASC')
      .map{|d| { 
        product_ndc:d.product_ndc,
        package_ndc:d.package_ndc,
        description:d.description,
        price_per_unit:d.price_per_unit,
        unit:d.unit,
        manufacturer:d.manufacturers.first ? d.manufacturers.first.name : nil
      } }
  end

end
