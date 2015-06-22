class CreatePharmaClassEstablisheds < ActiveRecord::Migration
  def change
    create_table :pharma_class_establisheds do |t|
      t.string :product_ndc
      t.string :class_name

      t.timestamps null: false
    end
  end
end
