# frozen_string_literal: true

module GuildWars
  module Wiki
    class QuestParser
      def initialize(html)
        @doc = Nokogiri::HTML(html)
      end

      def quests
        results = []

        tables.each do |table|
          next unless quest_table?(table)

          headers = headers_for(table)
          indexes = column_indexes(headers)

          table.css("tr").drop(1).each do |row|
            cells = row.css("td")
            next if cells.empty?

            name = link_text(cells[indexes[:quest]])
            next unless name

            results << {
              name: name,
              type: cell_text(cells[indexes[:type]]),
              profession: clean_profession(cell_text(cells[indexes[:profession]])),
              given_by: link_text(cells[indexes[:given_by]]),
              location: link_text(cells[indexes[:given_at]])
            }
          end
        end

        results.uniq
      end

      private

      def tables
        @doc.css("#mw-content-text table.sortable")
      end

      def quest_table?(table)
        headers = headers_for(table)

        headers.include?("Quest") &&
          headers.include?("Given at")
      end

      def headers_for(table)
        table.css("tr").first.css("th").map { |h| clean(h.text) }
      end

      def column_indexes(headers)
        {
          quest: headers.index("Quest"),
          type: headers.index("Type"),
          profession: headers.index("Profession"),
          given_by: headers.index("Given by"),
          given_at: headers.index("Given at")
        }
      end

      def link_text(cell)
        return unless cell

        link = cell.at_css("a")
        clean(link ? link.text : cell.text)
      end

      def cell_text(cell)
        clean(cell&.text)
      end

      def clean(value)
        value.to_s.gsub(/\s+/, " ").strip
      end

      def clean_profession(value)
        value
          .gsub(/\u00A0/, " ")
          .strip
          .gsub(/\s+/, " ")
      end
    end
  end
end
