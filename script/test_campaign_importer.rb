# frozen_string_literal: true

require_relative "../config/environment"

puts <<~BANNER

 ██████╗  █████╗ ███╗   ███╗██████╗
██╔════╝ ██╔══██╗████╗ ████║██╔══██╗
██║  ███╗███████║██╔████╔██║██████╔╝
██║   ██║██╔══██║██║╚██╔╝██║██╔═══╝
╚██████╔╝██║  ██║██║ ╚═╝ ██║██║
 ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝

    [ CAMPAIGN IMPORTER ONLINE ]
    [ TARGET: TYRIA DATABASE ]

BANNER

puts "[+] Fetching storyline..."

client = GuildWars::Wiki::Client.new

html = client.get("/wiki/Storyline")

puts "[+] Parsing campaigns..."

campaigns = GuildWars::Wiki::CampaignParser
  .new(html)
  .campaigns

puts "[+] Found #{campaigns.size} campaigns"

puts "[+] Importing..."

results = GuildWars::Import::Campaigns.call(
  campaigns: campaigns
)

puts
puts "Imported #{results.size} campaigns"

puts
puts "Database totals:"
puts "  Campaigns: #{Campaign.count}"

puts
puts "Campaigns:"

Campaign.order(:id).each do |campaign|
  puts <<~CAMPAIGN
    #{campaign.name}
      Slug: #{campaign.slug}
      Wiki: #{campaign.wiki_page}
  CAMPAIGN
end

puts
puts "✅ Campaign importer test passed"
