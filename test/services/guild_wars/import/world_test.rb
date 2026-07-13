require "test_helper"

class GuildWars::Import::WorldTest < ActiveSupport::TestCase
  class WikiClient
    def get(path)
      raise "Unexpected path: #{path}" unless path == "/wiki/Storyline"

      '<a href="#Guild_Wars_Prophecies">Guild Wars Prophecies</a>'
    end
  end

  test "imports campaigns through the world importer" do
    report = GuildWars::Import::World.call(client: WikiClient.new, target: :campaigns)

    assert_predicate report, :success?
    assert_equal 1, report.campaigns
    assert_equal "Guild Wars Prophecies", Campaign.find_by!(slug: "prophecies").name
  end

  test "rejects unsupported import targets" do
    error = assert_raises(ArgumentError) do
      GuildWars::Import::World.call(client: WikiClient.new, target: :invalid)
    end

    assert_equal "Unsupported import target: :invalid", error.message
  end
end
