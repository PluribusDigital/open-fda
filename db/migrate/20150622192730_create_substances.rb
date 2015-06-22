class CreateSubstances < ActiveRecord::Migration
  def change
    create_table :substances do |t|
      t.string :product_ndc
      t.string :name

      t.timestamps null: false
    end
  end
end
