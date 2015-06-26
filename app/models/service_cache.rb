class ServiceCache < ActiveRecord::Base

  def self.cache_timeframe
    1.day # default, override in subclass
  end

  def self.all_records
    self.base_where_clause
  end

  def self.find(key)
    match = self.base_where_clause.where(key:key).limit(1)
    return match.present? ? parse_data(match.first.data) : nil
  end

  def self.cache_exists?(key)
    last_update = self.base_where_clause.where(key:key).limit(1)
      .select(:updated_at).limit(1).pluck(:updated_at).first
    return last_update && last_update > cache_timeframe.ago
  end

  def self.delete_cache(key)
    self.base_where_clause.where(key:key).limit(1).first.destroy
  end

  def self.clean_cache
    self.base_where_clause
      .where(["updated_at < ?", cache_timeframe.ago])
      .each{|c|c.destroy}
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
    # Disable SQL Logging 
    logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil
    # Write
    cache = ServiceCache.find_or_initialize_by(service:self.new.class.to_s,key:key)
    cache.data = cache.data || {}
    cache.update(data: cache.data.merge(data) )
    # Reenable SQL Logging
    ActiveRecord::Base.logger = logger
  end

  def self.parse_data(datablob)
    # Hstore will do a 1-level key-value hash, but doesn't handle nested JSON well
    # Find those pairs and parse them
    # rescue the parse in case we are trying to parse a plain old string/value
    datablob.each do |key,val|
      datablob[key] = JSON.parse(val.gsub('=>',':')) rescue val 
    end
  end
  
end
