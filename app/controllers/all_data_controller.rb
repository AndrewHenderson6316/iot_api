class AllDataController < ApplicationController
  def index
    # Fetch all data with associations
    data_entries = DataEntry.includes(:device, :time_of_sample, :data_type)

    # Format the data as JSON
    formatted_data = data_entries.map do |entry|
      {
        id: entry.id,
        value: entry.value,
        data_type: {
          typeName: entry.data_type&.typeName,
          scale: entry.data_type&.scale
        },
        time_of_sample: {
          date: entry.time_of_sample&.date
        },
        device: {
          manufacturer_name: entry.device&.manufacturer_name,
          model: entry.device&.model,
          friendly_name: entry.device&.friendly_name
        },
        sensor: {
          manufacturer_name: entry.sensor&.manufacturer_name,
          serial_number: entry.sensor&.serial_number,
          catagory: entry.sensor&.catagory
        }
      }
    end

    render json: formatted_data
  end
end
