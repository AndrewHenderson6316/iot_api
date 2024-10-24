class CreateDevices < ActiveRecord::Migration[7.0]
  def change
    create_table :devices do |t|
      t.string :manufacturer_name
      t.string :description
      t.string :friendly_name
      t.string :model
      t.string :serial_number
      t.string :firmware_version
      t.string :software_version
      t.string :custom_id

      t.timestamps
    end
  end
end
