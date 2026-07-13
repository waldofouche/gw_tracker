# frozen_string_literal: true

module GuildWars
  module Import
    class World
      def self.call(
        client: GuildWars::Wiki::Client.new,
        target: :all,
        campaign: nil,
        debug: false
      )
        new(
          client: client,
          target: target.to_sym,
          campaign: campaign,
          debug: debug
        ).call
      end

      def initialize(client:, target:, campaign:, debug:)
        @client = client
        @target = target
        @campaign = campaign
        @debug = debug
        @report = GuildWars::Import::Report.new
      end

      def call
        import_campaigns if import_all? || import_campaigns?

        if import_all? || import_quests?
          import_quest_data
        end

        @report
      end

      private

      def import_quest_data
        campaigns =
          if @campaign
            [ Campaign.find_by!(slug: @campaign) ]
          else
            Campaign.find_each
          end

        campaigns.each do |campaign|
          import_quests(campaign)
        rescue StandardError => e
          report_error(campaign, e)
        end
      end

      def import_all?
        @target == :all
      end

      def import_campaigns?
        @target == :campaigns
      end

      def import_quests?
        @target == :quests
      end

      def import_campaigns
        debug "Fetching campaign storyline"

        html = @client.get("/wiki/Storyline")

        campaigns =
          GuildWars::Wiki::CampaignParser
            .new(html)
            .campaigns

        debug "Found #{campaigns.size} campaigns"

        GuildWars::Import::Campaigns.call(
          campaigns: campaigns,
          report: @report
        )
      rescue StandardError => e
        @report.error!(
          "Failed importing campaigns",
          e
        )
      end

      def import_quests(campaign)
        page =
          GuildWars::Wiki::PageResolver.quest_page(campaign)

        unless page
          @report.skip!(
            "#{campaign.name}: no quest page"
          )
          return
        end

        debug "Fetching #{campaign.name}: #{page}"

        html = @client.get(page)

        quests =
          GuildWars::Wiki::QuestParser
            .new(html)
            .quests

        debug "Parsed #{quests.size} quests"

        GuildWars::Import::Quests.call(
          campaign: campaign,
          quests: quests,
          report: @report
        )
      end

      def debug(message)
        return unless @debug

        puts "[DEBUG] #{message}"
      end

      def report_error(campaign, error)
        @report.error!(
          "Failed importing #{campaign.name}: #{error.message}",
          error
        )

        Rails.logger.error(error.full_message)
      end
    end
  end
end
