class CreatePharmaClassMethods < ActiveRecord::Migration
  def change
    create_table :pharma_class_methods do |t|
      t.string :product_ndc
      t.string :class_name

      t.timestamps null: false
    end
  end
end
