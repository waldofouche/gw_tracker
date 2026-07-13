# script/test_campaign_scraper.rb
# frozen_string_literal: true

require_relative "../config/environment"

puts <<~BANNER

 ██████╗  █████╗ ███╗   ███╗██████╗
██╔════╝ ██╔══██╗████╗ ████║██╔══██╗
██║  ███╗███████║██╔████╔██║██████╔╝
██║   ██║██╔══██║██║╚██╔╝██║██╔═══╝
╚██████╔╝██║  ██║██║ ╚═╝ ██║██║
 ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝

    [ CAMPAIGN SCRAPER ONLINE ]

BANNER

client = GuildWars::Wiki::Client.new

html = client.get("/wiki/Storyline")

campaigns = GuildWars::Wiki::CampaignParser
  .new(html)
  .campaigns

puts
puts "Found #{campaigns.size} campaigns"
puts

campaigns.each do |campaign|
  puts campaign[:name]
  puts "  slug: #{campaign[:slug]}"
  puts "  wiki: #{campaign[:wiki_page]}"
  puts
end

puts "✅ Campaign scraper test passed"
