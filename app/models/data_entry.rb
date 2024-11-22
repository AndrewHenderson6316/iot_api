class DataEntry < ApplicationRecord
    belongs_to :data_type
    belongs_to :device
    belongs_to :time_of_sample
    belongs_to :sensor
    accepts_nested_attributes_for :data_type
    accepts_nested_attributes_for :device
    accepts_nested_attributes_for :time_of_sample
    accepts_nested_attributes_for :sensor
end
