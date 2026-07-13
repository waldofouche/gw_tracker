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
        Rails.logger.info(
          "[GuildWars::Import::Quests] starting import of #{@quests.size} quest(s) " \
          "for campaign=#{@campaign.slug.inspect} (id=#{@campaign.id})"
        )

        imported_regions = Set.new
        succeeded = 0
        failed = 0

        @quests.each do |data|
          if import_one(data, imported_regions)
            succeeded += 1
          else
            failed += 1
          end
        end

        Rails.logger.info(
          "[GuildWars::Import::Quests] finished import for campaign=#{@campaign.slug.inspect}: " \
          "#{succeeded} succeeded, #{failed} failed, #{imported_regions.size} region(s) touched"
        )
      end

      private

      def import_one(data, imported_regions)
        Rails.logger.debug("[GuildWars::Import::Quests] processing raw_data=#{data.inspect}")

        region = find_or_create_region(data, imported_regions)
        quest = upsert_quest(region, data)

        @report.quest!
        Rails.logger.info(
          "[GuildWars::Import::Quests] #{quest.previous_changes.key?('id') ? 'created' : 'updated'} quest " \
          "name=#{quest.name.inspect} region=#{region.name.inspect} type=#{quest.quest_type.inspect} id=#{quest.id}"
        )

        quest
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error(
          "[GuildWars::Import::Quests] failed to import quest name=#{data[:name].inspect} " \
          "location=#{data[:location].inspect}: #{e.message} " \
          "errors=#{e.record.errors.full_messages.inspect}"
        )
        nil
      rescue StandardError => e
        Rails.logger.error(
          "[GuildWars::Import::Quests] unexpected error importing quest name=#{data[:name].inspect}: " \
          "#{e.class} #{e.message}"
        )
        Rails.logger.debug(e.backtrace&.first(10)&.join("\n"))
        nil
      end

      def find_or_create_region(data, imported_regions)
        region_name = clean(data[:location])
        region = Region.find_or_initialize_by(
          campaign: @campaign,
          name: region_name
        )
        was_new = region.new_record?

        region.save!

        if imported_regions.add?(region.id)
          @report.region!
          Rails.logger.info(
            "[GuildWars::Import::Quests] #{was_new ? 'created' : 'reused'} region " \
            "name=#{region_name.inspect} id=#{region.id}"
          )
        else
          Rails.logger.debug(
            "[GuildWars::Import::Quests] region name=#{region_name.inspect} id=#{region.id} already counted this run"
          )
        end

        region
      end

      def upsert_quest(region, data)
        quest_name = clean(data[:name])
        quest = Quest.find_or_initialize_by(
          region: region,
          name: quest_name
        )

        attrs = {
          quest_type: normalize_type(data[:type]),
          given_by: clean(data[:given_by]),
          profession: clean(data[:profession])
        }
        Rails.logger.debug(
          "[GuildWars::Import::Quests] quest=#{quest_name.inspect} attrs=#{attrs.inspect} " \
          "new_record=#{quest.new_record?}"
        )

        quest.update!(attrs)
        quest
      end

      def normalize_type(value)
        type = clean(value)
          .downcase
          .gsub("-", "_")
          .to_sym

        if Quest.quest_types.key?(type)
          type
        else
          Rails.logger.warn(
            "[GuildWars::Import::Quests] unknown quest type #{value.inspect}, defaulting to :secondary"
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
