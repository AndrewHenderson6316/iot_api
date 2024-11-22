class DataEntriesController < ApplicationController
    before_action :set_entry, only: %i[ show update destory ]
    
    def index 
        @data_entries = DataEntry.all

        render json: @data_entries
    end

  # GET /groups/1
  def show
    render json: @data_entry
  end

  # POST /groups
  def create
    #data = params.require(:data_entry).permit(:value, data_type: {}, device: {}, time_of_sample: {}, sensor: {})
    ActiveRecord::Base.transaction do
      # Logging the start of the transaction
      Rails.logger.debug("Starting transaction...")
  
      # DataType
      #Rails.logger.debug("Received data_type: #{data_entry_params[:data_type]}")
      data_type = DataType.find_or_create_by!(typeName: data_entry_params.dig(:data_type,:typeName)) do |dt|
        dt.scale = data_entry_params[:data_type][:scale]
        dt.description = data_entry_params[:data_type][:description]
      end
      #Rails.logger.debug("Created/Found data_type: #{data_type.inspect}")
  
      # Device
      # Rails.logger.debug("Received device: #{data_entry_params[:device]}")
      device = Device.find_or_create_by!(data_entry_params) do |dev|
        # dev.manufacturer_name = data_entry_params[:device][:manufacturer_name]
        # dev.description = data_entry_params[:device][:description]
        # dev.friendly_name = data_entry_params[:device][:friendly_name]
        # dev.model = data_entry_params[:device][:model]
        # dev.serial_number = data_entry_params[:device][:serial_number]
        # dev.firmware_version = data_entry_params[:device][:firmware_version]
        # dev.software_version = data_entry_params[:device][:software_version]
        # dev.categories = data_entry_params[:device][:categories]
      end
      Rails.logger.debug("Created/Found device: #{device.inspect}")
  
      # Sensor
      Rails.logger.debug("Received sensor: #{data_entry_params[:sensor]}")
      sensor = Sensor.find_or_create_by!(serial_number: data_entry_params[:sensor][:serial_number]) do |sen|
        sen.manufacturer_name = data_entry_params[:sensor][:manufacturer_name]
        sen.device_id = device.id
        sen.serial_number = data_entry_params[:sensor][:serial_number]
        sen.category = data_entry_params[:sensor][:category]
      end
      Rails.logger.debug("Created/Found sensor: #{sensor.inspect}")
  
      # TimeOfSample
      time_of_sample = TimeOfSample.find_or_create_by!(date: data_entry_params[:time_of_sample][:date])
      Rails.logger.debug("Created/Found time_of_sample: #{time_of_sample.inspect}")
  
      # Create DataEntry with all related records
      @data_entry = DataEntry.create!(
        value: data_entry_params[:value],
        data_type_id: data_type.id,
        device_id: device.id,
        time_of_sample_id: time_of_sample.id,
        sensor_id: sensor.id
      )
      Rails.logger.debug("Created data_entry: #{@data_entry.inspect}")
    end

    if @data_entry.save
      render json: @data_entry, status: :created
    else
      Rails.logger.error("Validation Errors: #{@data_entry.errors.full_messages}")
      render json: { errors: @data_entry.errors.full_messages }, status: :unprocessable_entity
    end
  end
  

  # PATCH/PUT 
  def update
    if @data_entry.update(data_entry_params)
      render json: @data_entry
    else
      render json: @data_entry.errors, status: :unprocessable_entity
    end
  end

  # DELETE 
  def destroy
    @data_entry.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entry
      @data_entry = DataEntry.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def data_entry_params
      params.require(:data_entry).permit(
        :value,
        :data_type_id,
        :device_id,
        :time_of_sample_id,
        :sensor_id,
        time_of_sample_attributes:[
          :date
        ],
        device_attributes: [
          :manufacturer_name,
          :description,
          :friendly_name,
          :categories,
          :serial_number,
          :software_version,
          :custom_id,
          :firmware_version,
          :model
        ],
        data_type_attributes: [
          :typeName,
          :scale
        ],
        sensor_attributes:[
          :manufacturer_name,
          :serial_number,
          :category,
          :created_at,
          :updated_at,
        ]
      )
    end
    # def time_of_sample_params
    #   params.permit(
    #     :date
    #   )
    # end
    # def device_params
    #   params.permit(
    #       :manufacturer_name,
    #       :description,
    #       :friendly_name,
    #       :categories,
    #       :serial_number,
    #       :software_version,
    #       :custom_id,
    #       :firmware_version,
    #       :model)
    # end
    # def data_type_params
    #   params.permit(
    #       :typeName,
    #       :scale,
    #       :created_at,
    #       :updated_at)
    # end
    # def sensor_params
    #   params.permit(
    #       :manufacturer_name,
    #       :serial_number,
    #       :category,
    #       :created_at,
    #       :updated_at)
    # end

end