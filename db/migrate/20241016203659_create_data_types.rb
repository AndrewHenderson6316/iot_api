class CreateDataTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :data_types do |t|
      t.string :typeName
      t.string :scale
      t.string :description

      t.timestamps
    end
  end
end
