require "test_helper"

class GuildWars::Import::QuestsTest < ActiveSupport::TestCase
  test "upserts quests, counts each region once, and normalizes unknown types" do
    report = GuildWars::Import::Report.new

    GuildWars::Import::Quests.call(
      campaign: campaigns(:one),
      quests: [
        { name: "First quest", type: "Primary", profession: "", given_by: "Ava", location: "Ascalon" },
        { name: "Second quest", type: "Unlisted", profession: "Monk", given_by: "Ben", location: "Ascalon" }
      ],
      report: report
    )

    assert_equal 1, report.regions
    assert_equal 2, report.quests
    assert_equal "primary", Quest.find_by!(name: "First quest").quest_type
    assert_equal "secondary", Quest.find_by!(name: "Second quest").quest_type
  end
end
