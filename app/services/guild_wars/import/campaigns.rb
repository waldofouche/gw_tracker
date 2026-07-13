# frozen_string_literal: true

module GuildWars
  module Import
    class Campaigns
      def self.call(campaigns:, report:)
        new(campaigns, report).call
      end

      def initialize(campaigns, report)
        @campaigns = campaigns
        @report = report
      end

      def call
        Rails.logger.info("[GuildWars::Import::Campaigns] starting import of #{@campaigns.size} campaign(s)")

        results = @campaigns.map do |data|
          import_one(data)
        end

        Rails.logger.info(
          "[GuildWars::Import::Campaigns] finished import: " \
          "#{results.compact.size} succeeded, #{results.size - results.compact.size} failed"
        )

        results
      end

      private

      def import_one(data)
        slug = data[:slug]
        Rails.logger.debug("[GuildWars::Import::Campaigns] processing slug=#{slug.inspect} raw_data=#{data.inspect}")

        campaign = Campaign.find_or_initialize_by(slug: slug)
        is_new_record = campaign.new_record?

        attrs = {
          name: clean(data[:name]),
          wiki_page: data[:wiki_page],
          wiki_anchor: data[:wiki_anchor]
        }
        Rails.logger.debug("[GuildWars::Import::Campaigns] slug=#{slug.inspect} attrs=#{attrs.inspect} new_record=#{is_new_record}")

        campaign.update!(attrs)

        Rails.logger.info(
          "[GuildWars::Import::Campaigns] #{is_new_record ? 'created' : 'updated'} campaign " \
          "slug=#{slug.inspect} id=#{campaign.id} name=#{attrs[:name].inspect}"
        )

        @report.campaign!
        campaign
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error(
          "[GuildWars::Import::Campaigns] failed to import slug=#{slug.inspect}: #{e.message} " \
          "errors=#{e.record.errors.full_messages.inspect}"
        )
        nil
      rescue StandardError => e
        Rails.logger.error(
          "[GuildWars::Import::Campaigns] unexpected error importing slug=#{slug.inspect}: #{e.class} #{e.message}"
        )
        Rails.logger.debug(e.backtrace&.first(10)&.join("\n"))
        nil
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
