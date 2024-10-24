class AddColToDataEntry < ActiveRecord::Migration[7.0]
  def change
    add_column :data_entries, :value, :string
    add_column :devices, :categories, :string
    add_reference :data_entries, :data_type, null: false, foreign_key: true
    add_reference :data_entries, :device, null: false, foreign_key: true
    add_reference :data_entries, :time_of_sample, null: false, foreign_key: true
  end
end
