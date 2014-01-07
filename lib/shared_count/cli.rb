require "csv"
require "logger"
require "thread"
require "uri"
require "shared_count_api"

require_relative "../../config/initializers/dotenv"
require_relative "../../config/initializers/shared_count_api.rb"

require_relative "cli/version"

module SharedCount
  module Cli
    JOIN_TIMEOUT = 5 # seconds
    SLEEP_TIME = 2.5 # seconds
    MAX_RETRIES = 3
    LINES_PER_ITERATION = 1000
    MAX_CONCURRENCY = 50

    class << self
      attr_writer :concurrency, :iteration_size

      def run(lines)
        configure_shared_count_client
        logger.info "Using #{concurrency} threads"
        logger.info "The iteration size is #{iteration_size} URLs"

        iterations, mod =  lines.length.divmod(iteration_size)
        iterations += 1 if mod > 0
        results = Queue.new

        iterations.times do |iteration|
          logger.error "Iteration ##{iteration + 1}"
          queue = Queue.new
          from = iteration_size * iteration
          lines[from, iteration_size].each { |url| queue.push(url) }
          thread_count = [MAX_CONCURRENCY, lines.length].min

          threads = (0...thread_count).map do |thread|
            Thread.new(thread) do |thread|
              error = 0

              url = begin
                      queue.pop(true)
                    rescue ThreadError; end

              while url do
                url.chomp!
                uri = URI(url)
                host = uri.host || url[/\Ahttps?:\/\/([^\/]+)/, 1]
                url = "#{uri.scheme}://#{host}"

                response = nil
                begin
                  response = SharedCountApi::Client.new(url).response
                rescue SharedCountApi::Error
                  logger.error "[Thread ##{thread}] - error while processing '#{url}'"
                rescue => err
                  logger.error "[Thread ##{thread}] - error while processing '#{url}', retry: ##{error} - #{err.inspect}"
                  error += 1
                  sleep(SLEEP_TIME)
                  if error <= MAX_RETRIES
                    retry
                  else
                    queue.push(url)
                    break
                  end
                else
                  error = 0
                end

                if response
                  logger.debug "[Thread ##{thread}] - #{url}"

                  facebook_metrics = response.delete("Facebook")
                  facebook_metrics = {} unless facebook_metrics.is_a?(Hash)
                  values = response.values.unshift(url)
                  results.push(values.concat(facebook_metrics.values))
                else
                  logger.warn "[Thread ##{thread}] - no response for '#{url}'"
                end

                url = begin
                        queue.pop(true)
                      rescue ThreadError; end
              end
            end
          end

          threads.each do |thread|
            begin
              thread.join(JOIN_TIMEOUT)
            rescue => err
              logger.error "[Thread ##{thread}] - error while joining main thread: #{err.inspect}"
              logger.error "[Thread ##{thread}] - #{err.backtrace.join("\n")}"
            end
          end
        end


        CSV.generate do |csv|
          csv << %w(URL StumbleUpon Reddit Delicious GooglePlusOne Buzz Twitter Diggs Pinterest LinkedIn commentsbox_count click_count total_count comment_count like_count share_count)
          csv << []
          loop do
            begin
              arr = results.pop(true)
              csv << arr
            rescue ThreadError
              break
            end
          end
        end
      end

      def configure
        yield self
      end

      def concurrency
        @concurrency ||= MAX_CONCURRENCY
      end

      def iteration_size
        @iteration_size ||= LINES_PER_ITERATION
      end

    private

      def logger
        @logger ||= Logger.new("shared_count-cli.log").tap do |logger|
          logger.level = ENV["DEBUG"] ? Logger::DEBUG : Logger::ERROR
        end
      end

      def configure_shared_count_client
        SharedCountApi.configure do |config|
          config.apikey = ENV["SHARED_COUNT_APIKEY"]
        end
      end
    end
  end
end
