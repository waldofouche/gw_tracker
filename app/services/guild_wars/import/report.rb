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
        Rails.logger.debug("[GuildWars::Import::Report] skipped: #{message}")
      end

      def error!(message, exception = nil)
        @errors << { message: message, exception: exception }

        if exception
          Rails.logger.error("[GuildWars::Import::Report] error: #{message} (#{exception.class}: #{exception.message})")
          Rails.logger.debug(exception.backtrace&.first(10)&.join("\n"))
        else
          Rails.logger.error("[GuildWars::Import::Report] error: #{message}")
        end
      end

      def success?
        @errors.empty?
      end

      def summary
        status = success? ? "SUCCESS" : "FAILED"

        <<~SUMMARY

          ============================
          Guild Wars Import Report
          ============================

          Status:    #{status}

          Campaigns: #{@campaigns}
          Regions:   #{@regions}
          Quests:    #{@quests}

          Skipped:   #{@skipped.size}
          Errors:    #{@errors.size}

        SUMMARY
      end

      def print
        puts summary
        Rails.logger.info(summary)

        print_skipped
        print_errors
      end

      private

      def print_skipped
        return if @skipped.empty?

        puts "Skipped (#{@skipped.size}):"
        @skipped.each do |message|
          puts "  - #{message}"
          Rails.logger.warn("[GuildWars::Import::Report] skipped: #{message}")
        end
      end

      def print_errors
        return if @errors.empty?

        puts "Errors (#{@errors.size}):"
        @errors.each do |error|
          puts "  - #{error[:message]}"

          if error[:exception]
            puts "    #{error[:exception].class}: #{error[:exception].message}"
            Rails.logger.error(
              "[GuildWars::Import::Report] #{error[:message]} — " \
              "#{error[:exception].class}: #{error[:exception].message}"
            )
          else
            Rails.logger.error("[GuildWars::Import::Report] #{error[:message]}")
          end
        end
      end
    end
  end
end
