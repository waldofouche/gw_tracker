class Region < ApplicationRecord
  belongs_to :campaign
has_many :quests
has_many :missions
end
