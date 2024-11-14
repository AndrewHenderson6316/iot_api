class DataEntry < ApplicationRecord
    has_one :time_of_sample
    has_one :device
    has_one :data_type
    accepts_nested_attributes_for :data_type , :time_of_sample , :device   ## add sensor
end
