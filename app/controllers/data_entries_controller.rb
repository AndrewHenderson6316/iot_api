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
    @data_entry = DataEntry.new(data_entry_params)
    @data_type = @data_entry.build_dataType
    @time_of_sample = @data_entry.build_time_of_sample
    @device = @data_entry.build_device

    if @data_entry.save
      render json: @data_entry, status: :created, location: @data_entry
    else
      render json: @data_entry.errors, status: :unprocessable_entity
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
      params.require(:data_entry).permit(:value,:data_type_id,:device_id,:time_of_sample_id,[:date,:data_entry_id],[:manufaturer_name,:firmware_version,:model, :data_entry_id ],[ :typeName,:scale,:data_entry_id])
    end
end