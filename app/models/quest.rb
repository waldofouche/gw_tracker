# frozen_string_literal: true

class Quest < ApplicationRecord
  belongs_to :region

  enum :quest_type, {
    primary: 0,
    secondary: 1,
    profession: 2,
    mission: 3,
    mini_mission: 4,
    hero: 5,
    challenge: 6,
    dungeon: 7,
    repeatable: 8
  }
end