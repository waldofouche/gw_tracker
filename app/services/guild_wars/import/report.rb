# frozen_string_literal: true

module GuildWars
  module Import
    class Report
      attr_reader :campaigns,
                  :regions,
                  :quests,
                  :skipped,
                  :errors

      def initialize
        @campaigns = 0
        @regions = 0
        @quests = 0
        @skipped = []
        @errors = []
      end

      def campaign!
        @campaigns += 1
      end

      def region!
        @regions += 1
      end

      def quest!
        @quests += 1
      end

      def skip!(message)
        @skipped << message
      end

      def error!(message, exception = nil)
        @errors << {
          message: message,
          exception: exception
        }
      end

      def success?
        @errors.empty?
      end

      def summary
        <<~SUMMARY

          ============================
          Guild Wars Import Report
          ============================

          Campaigns: #{@campaigns}
          Regions:   #{@regions}
          Quests:    #{@quests}

          Skipped:   #{@skipped.size}
          Errors:    #{@errors.size}

        SUMMARY
      end

      def print
        puts summary

        return if success?

        puts "Errors:"
        @errors.each do |error|
          puts " - #{error[:message]}"
        end
      end
    end
  end
end
