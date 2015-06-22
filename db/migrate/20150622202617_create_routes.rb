class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.string :product_ndc
      t.string :route

      t.timestamps null: false
    end
  end
end
