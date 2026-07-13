# frozen_string_literal: true

module GuildWars
  module Import
    class Quests
      def self.call(campaign:, quests:, report:)
        new(campaign, quests, report).call
      end

      def initialize(campaign, quests, report)
        @campaign = campaign
        @quests = quests
        @report = report
      end

      def call
        imported_regions = Set.new

        @quests.each do |data|
          region = Region.find_or_initialize_by(
            campaign: @campaign,
            name: clean(data[:location])
          )
          region.save!

          @report.region! if imported_regions.add?(region.id)

          quest = Quest.find_or_initialize_by(
            region: region,
            name: clean(data[:name])
          )

          quest.update!(
            quest_type: normalize_type(data[:type]),
            given_by: clean(data[:given_by]),
            profession: clean(data[:profession])
          )

          @report.quest!
        end
      end

      private

      def normalize_type(value)
        type = clean(value)
          .downcase
          .gsub("-", "_")
          .to_sym

        if Quest.quest_types.key?(type)
          type
        else
          Rails.logger.warn(
            "Unknown quest type #{value.inspect}, defaulting to secondary"
          )

          :secondary
        end
      end

      def clean(value)
        value
          .to_s
          .gsub("\u00A0", " ")
          .strip
      end
    end
  end
end
