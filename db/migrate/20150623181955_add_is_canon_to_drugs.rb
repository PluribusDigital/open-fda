class AddIsCanonToDrugs < ActiveRecord::Migration
  def change
    add_column :drugs, :is_canon, :boolean
  end
end
