class ServiceCache < ActiveRecord::Base

  def self.find(key)
    match = self.base_where_clause.where(key:key).limit(1)
    return match.present? ? match.first.data : nil
  end

  def self.destroy(key)
    self.base_where_clause.where(key:key).limit(1).first.destroy
  end

  def self.where_key_value(key,value)
    self.base_where_clause.where("data -> ? = ? ",key,value)
  end

  def self.where_key_value_like(key,value)
    self.base_where_clause.where("lower(data->?) LIKE ?",key,"%#{value.downcase}%")
  end

private

  def self.base_where_clause
    ServiceCache.where(service:self.new.class.to_s)
  end

  def self.write_cache(key,data)
    cache = ServiceCache.find_or_initialize_by(service:self.new.class.to_s,key:key)
    cache.data = cache.data || {}
    cache.update(data: cache.data.merge(data) )
  end
  
end
