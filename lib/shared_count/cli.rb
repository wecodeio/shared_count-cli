require "csv"
require "shared_count_api"

require_relative "../../config/initializers/dotenv"
require_relative "../../config/initializers/shared_count_api.rb"

require_relative "cli/version"

module SharedCount
  module Cli
    class << self
      def run(lines)
        configure_shared_count_client

        CSV.generate do |csv|
          lines.each_with_index do |url, i|
            url.chomp!
            response = nil
            begin
              response = SharedCountApi::Client.new(url).response
            rescue SharedCountApi::Error
              next
            end

            facebook_metrics = response.delete("Facebook")
            if i.zero?
              keys = response.keys.unshift("URL")
              headers = keys.concat(facebook_metrics.keys)
              csv << headers
              csv << []
            end

            values = response.values.unshift(url)
            csv << values.concat(facebook_metrics.values)
          end
        end
      end

    private

      def configure_shared_count_client
        SharedCountApi.configure do |config|
          config.apikey = ENV["SHARED_COUNT_APIKEY"]
        end
      end
    end
  end
end
