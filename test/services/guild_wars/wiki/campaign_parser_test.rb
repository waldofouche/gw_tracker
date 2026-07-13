require "test_helper"

class GuildWars::Wiki::CampaignParserTest < ActiveSupport::TestCase
  test "extracts unique campaign metadata from storyline links" do
    html = <<~HTML
      <a href="#Guild_Wars_Prophecies">1 Guild Wars Prophecies</a>
      <a href="#Guild_Wars_Factions">Guild Wars&nbsp;Factions</a>
      <a href="#Guild_Wars_Prophecies">Guild Wars Prophecies</a>
      <a href="#Guild_Wars_Extra">Guild Wars Utopia</a>
    HTML

    assert_equal [
      {
        name: "Guild Wars Factions",
        slug: "factions",
        wiki_anchor: "Guild_Wars_Factions",
        wiki_page: "/wiki/Guild_Wars_Factions"
      },
      {
        name: "Guild Wars Prophecies",
        slug: "prophecies",
        wiki_anchor: "Guild_Wars_Prophecies",
        wiki_page: "/wiki/Guild_Wars_Prophecies"
      }
    ], GuildWars::Wiki::CampaignParser.new(html).campaigns
  end
end
