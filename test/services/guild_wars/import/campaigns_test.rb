require "test_helper"

class GuildWars::Import::CampaignsTest < ActiveSupport::TestCase
  test "upserts campaigns and records each imported campaign" do
    report = GuildWars::Import::Report.new

    campaigns = GuildWars::Import::Campaigns.call(
      campaigns: [
        {
          name: " Guild Wars Prophecies ",
          slug: "prophecies",
          wiki_page: "/wiki/Guild_Wars_Prophecies",
          wiki_anchor: "Guild_Wars_Prophecies"
        }
      ],
      report: report
    )

    campaign = campaigns.first
    assert_equal 1, report.campaigns
    assert_equal "Guild Wars Prophecies", campaign.name
    assert_equal "/wiki/Guild_Wars_Prophecies", campaign.wiki_page

    GuildWars::Import::Campaigns.call(
      campaigns: [ { name: "Updated", slug: "prophecies", wiki_page: "/wiki/Updated", wiki_anchor: "Updated" } ],
      report: report
    )

    assert_equal 1, Campaign.where(slug: "prophecies").count
    assert_equal "Updated", campaign.reload.name
    assert_equal 2, report.campaigns
  end
end
