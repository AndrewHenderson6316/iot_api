class DataEntry < ApplicationRecord
    belongs_to :data_type
    belongs_to :device
    belongs_to :time_of_sample
    accepts_nested_attributes_for :data_type , :time_of_sample , :device   ## add sensor
end
