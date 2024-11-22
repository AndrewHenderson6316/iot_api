class SensorDevice < ActiveRecord::Migration[7.0]
  def change
    add_reference :sensors, :device, null: false, foreign_key: true
  end
end
