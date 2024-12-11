class DataEntriesController < ApplicationController
    # Callback to set the data entry instance for specific actions
    before_action :set_entry, only: %i[ show update destory ]
    
    # GET /data_entries
    # Fetches all data entries and renders them as JSON
    def index 
        @data_entries = DataEntry.all

        render json: @data_entries
    end

  # GET /data_entries/:id
  # Fetches a specific data entry and renders it as JSON
  def show
    render json: @data_entry
  end

  # GET /data_entries/chart
  # Prepares data for rendering the chart table view for simulation visulalisation
  def chart
    @data_entries = DataEntry.includes(:device, :data_type, :sensor, :time_of_sample).all
    
    @message = "Hello World" # Example message to pass to the view
    render "data_entries/chart"
    
  end

  # GET /data_entries/chart
  # Prepares data for rendering the chart graphs view for simulation visulalisation
  def chart2
    @data_entries = DataEntry.includes(:device, :data_type, :sensor, :time_of_sample).all
    
    @message = "Hello World" # Example message to pass to the view
    render "data_entries/chart2"
    
  end

  # POST /data_entries
  # Creates a new data entry with nested attributes and associations
  def create
    # Permit nested parameters for data creation
    #data = params.require(:data_entry).permit(:value, data_type: {}, device: {}, time_of_sample: {}, sensor: {})
    data = data_entry_params
    ActiveRecord::Base.transaction do
      # Logging the start of the transaction
      Rails.logger.debug("Starting transaction...")
  
      # Handle DataType creation or retrieval
      Rails.logger.debug("Received data_type: #{data[:data_type_attributes]}")
      data_type = DataType.find_or_create_by!(typeName: data[:data_type_attributes][:typeName]) do |dt|
        dt.scale = data[:data_type_attributes][:scale]
        dt.description = data[:data_type_attributes][:description]
      end
      Rails.logger.debug("Created/Found data_type: #{data_type.inspect}")
  
      # Handle Device creation or retrieval
      Rails.logger.debug("Received device: #{data[:device_attributes]}")
      device = Device.find_or_create_by!(custom_id: data[:device_attributes][:custom_id]) do |dev|
        dev.manufacturer_name = data[:device_attributes][:manufacturer_name]
        dev.description = data[:device_attributes][:description]
        dev.friendly_name = data[:device_attributes][:friendly_name]
        dev.model = data[:device_attributes][:model]
        dev.serial_number = data[:device_attributes][:serial_number]
        dev.firmware_version = data[:device_attributes][:firmware_version]
        dev.software_version = data[:device_attributes][:software_version]
        dev.categories = data[:device_attributes][:categories]
      end
      Rails.logger.debug("Created/Found device: #{device.inspect}")
  
      # Handle Sensor creation or retrieval
      Rails.logger.debug("Received sensor: #{data[:sensor_attributes]}")
      sensor = Sensor.find_or_create_by!(serial_number: data[:sensor_attributes][:serial_number]) do |sen|
        sen.manufacturer_name = data[:sensor_attributes][:manufacturer_name]
        sen.device_id = device.id
        sen.serial_number = data[:sensor_attributes][:serial_number]
        sen.category = data[:sensor_attributes][:category]
      end
      Rails.logger.debug("Created/Found sensor: #{sensor.inspect}")
  
      # Handle TimeOfSample creation or retrieval
      time_of_sample = TimeOfSample.find_or_create_by!(date: data[:time_of_sample_attributes][:date])
      Rails.logger.debug("Created/Found time_of_sample: #{time_of_sample.inspect}")
  
      # Create the main DataEntry record
      @data_entry = DataEntry.create!(
        value: data[:value],
        data_type_id: data_type.id,
        device_id: device.id,
        time_of_sample_id: time_of_sample.id,
        sensor_id: sensor.id
      )
      Rails.logger.debug("Created data_entry: #{@data_entry.inspect}")
    end
  
    # Respond with the created data entry or handle validation errors
    if @data_entry.save
      render json: @data_entry, status: :created
    else
      Rails.logger.error("Validation Errors: #{@data_entry.errors.full_messages}")
      render json: { errors: @data_entry.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /data_entries/:id
  # Updates a specific data entry
  def update
    if @data_entry.update(data_entry_params)
      render json: @data_entry
    else
      render json: @data_entry.errors, status: :unprocessable_entity
    end
  end

  # DELETE /data_entries/:id
  # Deletes a specific data entry
  def destroy
    @data_entry.destroy
  end

  private
   # Callback to set a data entry instance based on the provided ID
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
          :device_id,
        ]
      )
    end
end