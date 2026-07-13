# frozen_string_literal: true

namespace :gw do
  desc "Import Guild Wars wiki data"
  task import: :environment do
    puts <<~BANNER

     ██████╗ ██╗    ██╗
    ██╔════╝ ██║    ██║
    ██║  ███╗██║ █╗ ██║
    ██║   ██║██║███╗██║
    ╚██████╔╝╚███╔███╔╝
     ╚═════╝  ╚══╝╚══╝

        [ GUILD WARS IMPORT ONLINE ]
        [ TARGET: TYRIA DATABASE ]

    BANNER

    Rails.logger = ActiveSupport::TaggedLogging.new(Logger.new($stdout))
  Rails.logger.level = Rails.env.production? ? Logger::INFO : Logger::DEBUG

    report = GuildWars::Import::World.call

    puts report.summary

    unless report.success?
      puts
      puts "Import failed:"

      report.errors.each do |error|
        puts " - #{error[:message]}"
      end

      exit(1)
    end

    puts "✅ Guild Wars import completed successfully"
  end
end
