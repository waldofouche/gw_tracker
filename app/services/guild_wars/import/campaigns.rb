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
        @campaigns.map do |data|
          Campaign.find_or_initialize_by(
            slug: data[:slug]
          ).tap do |campaign|
            campaign.update!(
              name: clean(data[:name]),
              wiki_page: data[:wiki_page],
              wiki_anchor: data[:wiki_anchor]
            )

            @report.campaign!
          end
        end
      end

      private

      def clean(value)
        value
          .to_s
          .gsub("\u00A0", " ")
          .strip
      end
    end
  end
end
