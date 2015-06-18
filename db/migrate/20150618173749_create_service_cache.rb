class CreateServiceCache < ActiveRecord::Migration
  def change
    enable_extension 'hstore' unless extension_enabled?('hstore')
    create_table :service_caches do |t|
      t.string :service
      t.string :key
      t.hstore :data
      t.timestamps null: false
    end
  end
end
