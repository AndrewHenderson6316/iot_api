class RawDataController < ApplicationController
  def index
    # Execute raw SQL query to fetch all data from the `data_entries` table
    sql = <<-SQL
      SELECT data_entries.*, devices.friendly_name AS device_name, time_of_samples.date AS sample_date
      FROM data_entries
      LEFT JOIN devices ON devices.id = data_entries.device_id
      LEFT JOIN time_of_samples ON time_of_samples.id = data_entries.time_of_sample_id
    SQL

    results = ActiveRecord::Base.connection.execute(sql)

    # Format the results as JSON
    formatted_results = results.map do |row|
      {
        id: row['id'],
        value: row['value'],
        device_name: row['device_name'],
        sample_date: row['sample_date']
      }
    end

    render json: formatted_results
  end
end
