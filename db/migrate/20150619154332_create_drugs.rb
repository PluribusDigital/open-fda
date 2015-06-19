class CreateDrugs < ActiveRecord::Migration
  def change
    create_table :drugs do |t|
      t.string :dea_schedule
      t.string :description
	  t.integer :labeler
	  t.string :nonproprietary_name
	  t.integer :package_code
	  t.string :package_ndc
	  t.decimal :price_per_unit, precision: 15, scale: 5
	  t.integer :product_code
	  t.string :product_ndc
	  t.string :proprietary_name
	  t.string :unit

      t.timestamps null: false
    end
  end
end
