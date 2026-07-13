require "test_helper"

class GuildWars::Wiki::QuestParserTest < ActiveSupport::TestCase
  test "extracts quests from wiki tables and ignores unrelated tables" do
    html = <<~HTML
      <div id="mw-content-text">
        <table class="sortable"><tr><th>Item</th></tr><tr><td>Ignore me</td></tr></table>
        <table class="sortable">
          <tr><th>Quest</th><th>Type</th><th>Profession</th><th>Given by</th><th>Given at</th></tr>
          <tr>
            <td><a> A Test Quest </a></td><td>Primary</td><td> Warrior&nbsp; </td>
            <td><a>Prince Rurik</a></td><td><a>Ascalon City</a></td>
          </tr>
        </table>
      </div>
    HTML

    assert_equal [
      {
        name: "A Test Quest",
        type: "Primary",
        profession: "Warrior",
        given_by: "Prince Rurik",
        location: "Ascalon City"
      }
    ], GuildWars::Wiki::QuestParser.new(html).quests
  end
end
