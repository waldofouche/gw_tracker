# frozen_string_literal: true

module GuildWars
  module Wiki
    class PageResolver
      QUEST_PAGES = {
        "prophecies" => "/wiki/Prophecies_quests",
        "factions" => "/wiki/Factions_quests",
        "nightfall" => "/wiki/Nightfall_quests",
        "eye_of_the_north" => "/wiki/Eye_of_the_North_quests"
      }.freeze

      def self.quest_page(campaign)
        QUEST_PAGES[campaign.slug]
      end
    end
  end
end
