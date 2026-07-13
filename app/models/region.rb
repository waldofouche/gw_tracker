class Region < ApplicationRecord
  belongs_to :campaign
  has_many :missions, dependent: :destroy
  has_many :quests, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :campaign_id }
end
