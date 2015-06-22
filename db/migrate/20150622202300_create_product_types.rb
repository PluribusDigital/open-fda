class CreateProductTypes < ActiveRecord::Migration
  def change
    create_table :product_types do |t|
      t.string :product_ndc
      t.string :type_name

      t.timestamps null: false
    end
  end
end
