class ValueDrop < ActiveRecord::Migration[7.0]
  def change
    remove_column :data_entries, :value
    add_column :data_entries, :value, :float
  end
end
