# frozen_string_literal: true

module GuildWars
  module Wiki
    class CampaignParser
      CAMPAIGN_PATTERN = /\AGuild[ ]Wars[ ](?:
        Prophecies|
        Factions|
        Nightfall|
        Eye[ ]of[ ]the[ ]North|
        Beyond
      )\z/x.freeze

      def initialize(html)
        @doc = Nokogiri::HTML(html)
        Rails.logger.debug(
          "[GuildWars::Wiki::CampaignParser] initialized with html length=#{html&.length}"
        )
      end

      def campaigns
        candidates = @doc.css("a[href^='#Guild_Wars_']")
        Rails.logger.debug(
          "[GuildWars::Wiki::CampaignParser] found #{candidates.size} anchor(s) matching href selector"
        )

        parsed = candidates.filter_map do |link|
          name = clean_text(link.text)
          href = link.attribute("href")&.value

          unless name.match?(CAMPAIGN_PATTERN)
            Rails.logger.debug(
              "[GuildWars::Wiki::CampaignParser] skipping anchor name=#{name.inspect} href=#{href.inspect} (no pattern match)"
            )
            next
          end

          clean_name = name.sub(/^\d+\s*/, "")

          campaign = {
            name: clean_name,
            slug: slugify(clean_name),
            wiki_anchor: href.delete_prefix("#"),
            wiki_page: wiki_page(clean_name)
          }

          Rails.logger.debug("[GuildWars::Wiki::CampaignParser] matched campaign=#{campaign.inspect}")
          campaign
        end

        before_dedup = parsed.size
        result = parsed.uniq { |c| c[:slug] }.sort_by { |c| c[:slug] }

        if before_dedup != result.size
          Rails.logger.warn(
            "[GuildWars::Wiki::CampaignParser] deduped #{before_dedup - result.size} duplicate slug(s)"
          )
        end

        Rails.logger.info(
          "[GuildWars::Wiki::CampaignParser] parsed #{result.size} unique campaign(s): " \
          "#{result.map { |c| c[:slug] }.inspect}"
        )

        result
      end

      private

      def clean_text(value)
        value
          .to_s
          .gsub("\u00A0", " ")
          .strip
          .gsub(/\s+/, " ")
      end

      def slugify(name)
        name
          .delete_prefix("Guild Wars ")
          .downcase
          .gsub(" ", "_")
      end

      def wiki_page(name)
        "/wiki/#{name.gsub(' ', '_')}"
      end
    end
  end
end
