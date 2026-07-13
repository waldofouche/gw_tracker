# frozen_string_literal: true

class Campaign < ApplicationRecord
  has_many :regions, dependent: :destroy
  has_many :quests, through: :regions
end