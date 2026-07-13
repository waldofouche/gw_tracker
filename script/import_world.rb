# frozen_string_literal: true

require_relative "../config/environment"

puts <<~BANNER

 ██████╗ ██╗    ██╗
██╔════╝ ██║    ██║
██║  ███╗██║ █╗ ██║
██║   ██║██║███╗██║
╚██████╔╝╚███╔███╔╝
 ╚═════╝  ╚══╝╚══╝

 [ GUILD WARS WORLD IMPORTER ]
 [ TYRIA DATABASE SYNC ]

BANNER

GuildWars::Import::World.call

puts
puts "Database totals:"
puts "  Campaigns: #{Campaign.count}"
puts "  Regions:   #{Region.count}"
puts "  Quests:    #{Quest.count}"

puts
puts "✅ World import completed"