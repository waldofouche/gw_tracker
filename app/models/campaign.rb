class Campaign < ApplicationRecord
has_many :regions, dependent: :destroy
has_many :campaign_travels, foreign_key: :from_campaign_id
end
