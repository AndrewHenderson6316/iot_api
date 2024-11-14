class Api::V1::IotDataController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    # Permit nested parameters for data creation
    data = params.require(:data_entry).permit(:value, data_type: {}, device: {}, time_of_sample: {})

    ActiveRecord::Base.transaction do
      # Find or create the related records
      data_type = DataType.find_or_create_by!(typeName: data[:data_type][:typeName]) do |dt|
        dt.scale = data[:data_type][:scale]
        dt.description = data[:data_type][:description]
      end

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

      time_of_sample = TimeOfSample.find_or_create_by!(date: data[:time_of_sample][:date])

      # Create the DataEntry record
      DataEntry.create!(
        value: data[:value],
        data_type_id: data_type.id,
        device_id: device.id,
        time_of_sample_id: time_of_sample.id
      )
    end

    render json: { status: 'success', message: 'Data received and saved' }, status: :created
  rescue StandardError => e
    Rails.logger.error "Error saving IoT data: #{e.message}"
    render json: { status: 'error', message: e.message }, status: :unprocessable_entity
  end
end
