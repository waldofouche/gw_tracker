require "test_helper"

class RegionTest < ActiveSupport::TestCase
  test "requires a unique name within a campaign" do
    region = Region.new(campaign: regions(:one).campaign, name: regions(:one).name)

    assert_not_predicate region, :valid?
    assert_includes region.errors[:name], "has already been taken"
  end
end
