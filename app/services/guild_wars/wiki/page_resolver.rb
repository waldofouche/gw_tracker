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
        page = QUEST_PAGES[campaign.slug]

        if page
          Rails.logger.debug(
            "[GuildWars::Wiki::PageResolver] resolved campaign=#{campaign.slug.inspect} page=#{page.inspect}"
          )
        else
          Rails.logger.warn(
            "[GuildWars::Wiki::PageResolver] no quest page for campaign=#{campaign.slug.inspect} " \
            "(known slugs: #{QUEST_PAGES.keys.inspect})"
          )
        end

        page
      end
    end
  end
end
