# frozen_string_literal: true

require_relative "../config/environment"

puts <<~BANNER

 ██████╗  █████╗ ███╗   ███╗██████╗
██╔════╝ ██╔══██╗████╗ ████║██╔══██╗
██║  ███╗███████║██╔████╔██║██████╔╝
██║   ██║██╔══██║██║╚██╔╝██║██╔═══╝
╚██████╔╝██║  ██║██║ ╚═╝ ██║██║
 ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝

    [ QUEST IMPORTER ONLINE ]
    [ TARGET: TYRIA DATABASE ]

BANNER

puts "[+] Loading campaign..."

campaign = Campaign.find_by!(slug: "prophecies")

puts "[+] Campaign: #{campaign.name}"

client = GuildWars::Wiki::Client.new

page = "/wiki/Prophecies_quests"

puts "[+] Fetching #{page}..."

html = client.get(page)

puts "[+] Parsing quests..."

quests = GuildWars::Wiki::QuestParser
  .new(html)
  .quests

puts "[+] Found #{quests.size} quests"

puts "[+] Importing..."

GuildWars::Import::Quests.call(
  campaign: campaign,
  quests: quests
)

puts "[+] Import complete"

puts
puts "Database totals:"
puts "  Campaigns: #{Campaign.count}"
puts "  Quests:    #{Quest.count}"

puts
puts "Sample quests:"

campaign.quests.limit(10).each do |quest|
  puts <<~QUEST
    #{quest.name}
      Type: #{quest.quest_type}
      Location: #{quest.region.name}
      Given by: #{quest.given_by}
      Profession: #{quest.profession}
  QUEST
end

puts
puts "✅ Quest importer test passed"
