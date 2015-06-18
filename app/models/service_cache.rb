class ServiceCache < ActiveRecord::Base

  def self.find(key)
    data = ServiceCache.where(service:self.new.class.to_s, key:key).limit(1).first.data
  end

  def self.destroy(key)
    ServiceCache.where(service:self.new.class.to_s, key:key).limit(1).first.destroy
  end

private

  def self.write_cache(key,data)
    cache = ServiceCache.find_or_initialize_by(service:self.new.class.to_s,key:key)
    cache.data = cache.data || {}
    cache.update(data: cache.data.merge(data) )
  end
  
end
