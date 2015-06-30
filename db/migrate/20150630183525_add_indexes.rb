class AddIndexes < ActiveRecord::Migration
  def change
    add_index :drugs, :product_ndc
    add_index :drugs, :proprietary_name
    add_index :drugs, :is_canon
    add_index :drugs, :nonproprietary_name
    add_index :manufacturers, :name
    add_index :substances, :name
    add_index :routes, :product_ndc
    add_index :pharma_class_establisheds, :product_ndc
    add_index :service_caches, :service
    add_index :service_caches, :key
  end
end
