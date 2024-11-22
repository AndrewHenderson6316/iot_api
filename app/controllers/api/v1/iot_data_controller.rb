class Api::V1::IotDataController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    # Permit nested parameters for data creation
    data = params.require(:data_entry).permit(:value, data_type: {}, device: {}, time_of_sample: {})

    ActiveRecord::Base.transaction do
      # Find or create the related records
      Rails.logger.debug("Starting transaction...")
    
      # DataType
      Rails.logger.debug("Received data_type: #{data[:data_type]}")
      data_type = DataType.find_or_create_by!(typeName: data[:data_type][:typeName]) do |dt|
        dt.scale = data[:data_type][:scale]
        dt.description = data[:data_type][:description]
      end
      Rails.logger.debug("Created/Found data_type: #{data_type.inspect}")
    
      # Device
      Rails.logger.debug("Received device: #{data[:device]}")
      device = Device.find_or_create_by!(custom_id: data[:device][:custom_id]) do |dev|
        dev.manufacturer_name = data[:device][:manufacturer_name]
        dev.description = data[:device][:description]
        dev.friendly_name = data[:device][:friendly_name]
        dev.model = data[:device][:model]
        dev.serial_number = data[:device][:serial_number]
        dev.firmware_version = data[:device][:firmware_version]
        dev.software_version = data[:device][:software_version]
        dev.categories = data[:device][:categories]
      end
      Rails.logger.debug("Created/Found device: #{device.inspect}")
    
      # Sensor
      Rails.logger.debug("Received sensor: #{data[:sensor]}")
      sensor = Sensor.find_or_create_by!(serial_number: data[:sensor][:serial_number]) do |sen|
        sen.manufacturer_name = data[:sensor][:manufacturer_name]
        sen.device_id = device.id
        sen.serial_number = data[:sensor][:serial_number]
        sen.category = data[:sensor][:category]
      end
      Rails.logger.debug("Created/Found sensor: #{sensor.inspect}")
    
      Rails.logger.debug("Transaction completed successfully.")
    end

      time_of_sample = TimeOfSample.find_or_create_by!(date: data[:time_of_sample][:date])

     # Create DataEntry with all related records
    @data_entry = DataEntry.create!(
        value: data[:value],
        data_type_id: data_type.id,
        device_id: device.id,
        time_of_sample_id: time_of_sample.id,
        sensor_id: sensor.id
      )


    if @data_entry.save
      render json: @data_entry, status: :created
    else
      Rails.logger.error("Validation Errors: #{@data_entry.errors.full_messages}")
      render json: { errors: @data_entry.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
