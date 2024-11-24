class RawDataController < ApplicationController
  def index
    # Execute raw SQL query to fetch the most recent data for each sensor
    sql = <<-SQL
      SELECT 
        MAX(data_entries.id) AS id,
        data_entries.value,
        devices.friendly_name AS device_name,
        MAX(time_of_samples.date) AS sample_date,
        data_entries.sensor_id
      FROM data_entries
      LEFT JOIN devices ON devices.id = data_entries.device_id
      LEFT JOIN time_of_samples ON time_of_samples.id = data_entries.time_of_sample_id
      GROUP BY devices.id, data_entries.sensor_id
    SQL

    results = ActiveRecord::Base.connection.execute(sql)

    # Format the results as JSON
    formatted_results = results.map do |row|
      {
        id: row['costum_id'],
        value: row['value'],
        device_name: row['device_name'],
        sample_date: row['sample_date'],
        sensor_id: row['sensor_id']
      }
    end

    render json: formatted_results
  end
end
