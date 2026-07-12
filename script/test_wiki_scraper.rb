# frozen_string_literal: true

require_relative "../config/environment"

GREEN = "\e[32m"
CYAN = "\e[36m"
YELLOW = "\e[33m"
RED = "\e[31m"
RESET = "\e[0m"

puts <<~ASCII
#{CYAN}
 ██████╗ ██╗    ██╗        ██╗    ██╗██╗██╗  ██╗██╗
██╔════╝ ██║    ██║        ██║    ██║██║██║ ██╔╝██║
██║  ███╗██║ █╗ ██║        ██║ █╗ ██║██║█████╔╝ ██║
██║   ██║██║███╗██║        ██║███╗██║██║██╔═██╗ ██║
╚██████╔╝╚███╔███╔╝        ╚███╔███╔╝██║██║  ██╗██║
 ╚═════╝  ╚══╝╚══╝          ╚══╝╚══╝ ╚═╝╚═╝  ╚═╝╚═╝
#{'                                                   '}
███████╗ ██████╗██████╗  █████╗ ██████╗ ███████╗██████╗#{' '}
██╔════╝██╔════╝██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗
███████╗██║     ██████╔╝███████║██████╔╝█████╗  ██████╔╝
╚════██║██║     ██╔══██╗██╔══██║██╔═══╝ ██╔══╝  ██╔══██╗
███████║╚██████╗██║  ██║██║  ██║██║     ███████╗██║  ██║
╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝

        [ GUILD WARS :: WIKI SCRAPER INITIALISING ]
        [ TARGET: TYRIA DATABASE ]
        [ STATUS: ONLINE ]
#{RESET}
ASCII

puts "#{GREEN}[+] Loading Rails environment...#{RESET}"
require_relative "../config/environment"

puts "#{GREEN}[+] Wiki scraper online#{RESET}"
puts

client = GuildWars::Wiki::Client.new

page = "/wiki/Prophecies_quests"

puts "#{CYAN}[>] Target page: #{page}#{RESET}"
puts "#{CYAN}[>] Fetching wiki data...#{RESET}"

html = client.get(page)

puts "#{GREEN}[+] Download complete: #{html.bytesize} bytes received#{RESET}"

puts "#{CYAN}[>] Initialising Quest parser...#{RESET}"

parser = GuildWars::Wiki::QuestParser.new(html)

puts "#{GREEN}[+] Parser ready#{RESET}"

quests = parser.quests

puts
puts "#{YELLOW}╔══════════════════════════════════════╗#{RESET}"
puts "#{YELLOW}║        QUEST DATABASE RESULTS        ║#{RESET}"
puts "#{YELLOW}╚══════════════════════════════════════╝#{RESET}"
puts

puts "#{GREEN}[+] Found #{quests.count} quests#{RESET}"
puts

quests.first(10).each_with_index do |quest, index|
  puts "#{CYAN}#{index + 1}. #{quest[:name]}#{RESET}"
  puts "   Type:       #{quest[:type]}"
  puts "   Profession: #{quest[:profession]}"
  puts "   Given by:   #{quest[:given_by]}"
  puts "   Given at:   #{quest[:location]}"
  puts
end

if quests.empty?
  puts "#{RED}[!] ERROR: No quests found!#{RESET}"
  abort
end

puts <<~ASCII

#{GREEN}
  ╔════════════════════════════════════════════╗
  ║  ✓ WIKI SCRAPER TEST COMPLETE             ║
  ║  ✓ QUEST DATA INGESTION SUCCESSFUL        ║
  ║  ✓ TYRIA DATABASE CONNECTION VERIFIED     ║
  ╚════════════════════════════════════════════╝
#{RESET}

ASCII
