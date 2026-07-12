class Quest < ApplicationRecord
belongs_to :region

enum :quest_type, {
  primary: 0,
  secondary: 1,
  profession: 2
}
end
