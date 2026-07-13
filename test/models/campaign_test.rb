require "test_helper"

class CampaignTest < ActiveSupport::TestCase
  test "requires a unique slug" do
    campaign = Campaign.new(name: "Duplicate", slug: campaigns(:one).slug)

    assert_not_predicate campaign, :valid?
    assert_includes campaign.errors[:slug], "has already been taken"
  end
end
