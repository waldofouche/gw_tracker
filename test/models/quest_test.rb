require "test_helper"

class QuestTest < ActiveSupport::TestCase
  test "requires a unique name within a region" do
    quest = Quest.new(region: quests(:one).region, name: quests(:one).name)

    assert_not_predicate quest, :valid?
    assert_includes quest.errors[:name], "has already been taken"
  end
end
