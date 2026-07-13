require "test_helper"

class MissionTest < ActiveSupport::TestCase
  test "requires a name" do
    mission = Mission.new(region: regions(:one))

    assert_not_predicate mission, :valid?
    assert_includes mission.errors[:name], "can't be blank"
  end
end
