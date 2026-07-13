# frozen_string_literal: true

module GuildWars
  module Import
    class World
      def self.call(
        client: GuildWars::Wiki::Client.new,
        target: :all,
        campaign: nil
      )
        new(
          client: client,
          target: target.to_sym,
          campaign: campaign
        ).call
      end

      def initialize(client:, target:, campaign:)
        unless %i[all campaigns quests].include?(target)
          raise ArgumentError, "Unsupported import target: #{target.inspect}"
        end

        @client = client
        @target = target
        @campaign = campaign
        @report = GuildWars::Import::Report.new
      end

      def call
        Rails.logger.info(
          "[GuildWars::Import::World] starting import target=#{@target.inspect}" +
          (@campaign ? " campaign=#{@campaign.inspect}" : " campaign=all")
        )

        import_campaigns if import_all? || import_campaigns?
        import_quest_data if import_all? || import_quests?

        Rails.logger.info("[GuildWars::Import::World] import complete")
        Rails.logger.info(@report.summary)

        @report
      end

      private

      def import_quest_data
        campaigns =
          if @campaign
            Rails.logger.info("[GuildWars::Import::World] resolving single campaign slug=#{@campaign.inspect}")
            [ Campaign.find_by!(slug: @campaign) ]
          else
            Rails.logger.info("[GuildWars::Import::World] resolving all campaigns from database")
            Campaign.find_each
          end

        count = 0
        campaigns.each do |campaign|
          count += 1
          Rails.logger.info("[GuildWars::Import::World] importing quests for campaign=#{campaign.slug.inspect} (id=#{campaign.id})")
          import_quests(campaign)
        rescue StandardError => e
          report_error(campaign, e)
        end

        Rails.logger.info("[GuildWars::Import::World] quest import loop finished, processed #{count} campaign(s)")
      end

      def import_campaigns
        Rails.logger.info("[GuildWars::Import::World] fetching campaign storyline from wiki")

        html = @client.get("/wiki/Storyline")
        Rails.logger.debug("[GuildWars::Import::World] fetched storyline html length=#{html&.length}")

        campaigns = GuildWars::Wiki::CampaignParser.new(html).campaigns
        Rails.logger.info("[GuildWars::Import::World] parsed #{campaigns.size} campaign(s) from storyline")

        GuildWars::Import::Campaigns.call(
          campaigns: campaigns,
          report: @report
        )
      rescue StandardError => e
        Rails.logger.error("[GuildWars::Import::World] failed to import campaigns: #{e.class} #{e.message}")
        Rails.logger.debug(e.backtrace&.first(10)&.join("\n"))
        @report.error!("Failed importing campaigns", e)
      end

      def import_quests(campaign)
        page = GuildWars::Wiki::PageResolver.quest_page(campaign)

        unless page
          Rails.logger.info(
            "[GuildWars::Import::World] skipping campaign=#{campaign.slug.inspect} — no quest page resolved"
          )
          @report.skip!("#{campaign.name}: no quest page")
          return
        end

        Rails.logger.info(
          "[GuildWars::Import::World] fetching quest page for campaign=#{campaign.slug.inspect} page=#{page.inspect}"
        )
        html = @client.get(page)
        Rails.logger.debug("[GuildWars::Import::World] fetched quest page html length=#{html&.length}")

        quests = GuildWars::Wiki::QuestParser.new(html).quests
        Rails.logger.info(
          "[GuildWars::Import::World] parsed #{quests.size} quest(s) for campaign=#{campaign.slug.inspect}"
        )

        GuildWars::Import::Quests.call(
          campaign: campaign,
          quests: quests,
          report: @report
        )
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

      def report_error(campaign, error)
        Rails.logger.error(
          "[GuildWars::Import::World] failed importing quests for campaign=#{campaign.slug.inspect} " \
          "(id=#{campaign.id}): #{error.class} #{error.message}"
        )
        Rails.logger.debug(error.full_message)

        @report.error!("Failed importing #{campaign.name}: #{error.message}", error)
      end
    end
  end
end
