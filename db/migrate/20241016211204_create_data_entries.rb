class CreateDataEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :data_entries do |t|

      t.timestamps
    end
  end
end
