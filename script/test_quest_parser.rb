# frozen_string_literal: true

require_relative "../config/environment"

puts <<~BANNER

 ██████╗  █████╗ ███╗   ███╗██████╗
██╔════╝ ██╔══██╗████╗ ████║██╔══██╗
██║  ███╗███████║██╔████╔██║██████╔╝
██║   ██║██╔══██║██║╚██╔╝██║██╔═══╝
╚██████╔╝██║  ██║██║ ╚═╝ ██║██║
 ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝

    [ QUEST PARSER ONLINE ]
    [ TARGET: TYRIA QUEST DATABASE ]

BANNER

puts "[+] Loading Rails environment..."

client = GuildWars::Wiki::Client.new

page = "/wiki/Prophecies_quests"

puts "[+] Fetching #{page}..."

html = client.get(page)

puts "[+] Downloaded #{html.bytesize} bytes"

puts "[+] Parsing quests..."

quests = GuildWars::Wiki::QuestParser
  .new(html)
  .quests

puts
puts "Found #{quests.size} quests"

puts

quests.first(10).each_with_index do |quest, index|
  puts "#{index + 1}. #{quest[:name]}"

  puts "   Type:       #{quest[:type]}"
  puts "   Profession: #{quest[:profession]}"
  puts "   Given by:   #{quest[:given_by]}"
  puts "   Location:   #{quest[:location]}"
  puts
end

raise "No quests parsed" if quests.empty?

required_fields = %i[
  name
  type
  profession
  given_by
  location
]

invalid = quests.reject do |quest|
  required_fields.all? { |field| quest.key?(field) }
end

raise "Missing quest fields: #{invalid.inspect}" if invalid.any?

puts "✅ Quest parser test passed"
