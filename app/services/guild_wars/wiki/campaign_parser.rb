# frozen_string_literal: true

module GuildWars
  module Wiki
    class CampaignParser
      CAMPAIGN_PATTERN = /
        Guild\ Wars\ 
        (?<name>
          Prophecies|
          Factions|
          Nightfall|
          Eye\ of\ the\ North|
          Beyond
        )
      /x.freeze

      def initialize(html)
        @doc = Nokogiri::HTML(html)
      end

      def campaigns
        @doc.css("a[href^='#Guild_Wars_']").filter_map do |link|
          name = clean_text(link.text)
          href = link.attribute("href")&.value

          next unless name.match?(CAMPAIGN_PATTERN)

          clean_name = name.sub(/^\d+\s*/, "")

          {
            name: clean_name,
            slug: slugify(clean_name),
            wiki_anchor: href.delete_prefix("#"),
            wiki_page: wiki_page(clean_name)
          }
        end.uniq { |campaign| campaign[:slug] }
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