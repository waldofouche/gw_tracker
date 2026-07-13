require "test_helper"

class BrowsingTest < ActionDispatch::IntegrationTest
  test "campaign and quest catalogue pages render" do
    get campaigns_path
    assert_response :success
    assert_select "h1", "Campaigns"

    get campaign_path(campaigns(:one))
    assert_response :success
    assert_select "h1", campaigns(:one).name

    get quests_path(campaign_id: campaigns(:one).id)
    assert_response :success
    assert_select "h1", "All quests"
  end
end
