class CreateSensors < ActiveRecord::Migration[7.0]
  def change
    create_table :sensors do |t|

      t.string :manufacturer_name
      t.string :serial_number
      t.string :category
      t.timestamps
    end
    add_reference :data_entries, :sensor, null: false, foreign_key: true
  end
end
