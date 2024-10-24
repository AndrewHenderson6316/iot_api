class CreateTimeOfSamples < ActiveRecord::Migration[7.0]
  def change
    create_table :time_of_samples do |t|
      t.datetime :date

      t.timestamps
    end
  end
end
