class CreateManufacturers < ActiveRecord::Migration
  def change
    create_table :manufacturers do |t|
      t.string :product_ndc
      t.string :name

      t.timestamps null: false
    end
  end
end
