class ServiceCache < ActiveRecord::Base

  def self.find(key)
    match = ServiceCache.where(service:self.new.class.to_s, key:key).limit(1)
    return match.present? ? match.first.data : nil
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
