# frozen_string_literal: true

module GuildWars
  module Wiki
    class Client
      BASE_URL = "https://wiki.guildwars.com"

      def initialize
        @client = Faraday.new(url: BASE_URL) do |f|
          f.headers["User-Agent"] = "GWTracker/1.0"

          f.options.timeout = 10

          f.request :retry, {
            max: 3,
            interval: 1,
            backoff_factor: 2
          }

          f.adapter Faraday.default_adapter
        end
      end

      def get(path)
        response = @client.get(path)

        raise "Wiki request failed #{response.status}" unless response.success?

        response.body
      end
    end
  end
end
