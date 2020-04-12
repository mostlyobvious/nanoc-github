require "nanoc"
require "octokit"
require "concurrent-ruby"
require "faraday/http_cache"
require "pstore"

module Nanoc
  module Github
    REGEX = /^(?<metadata>---\s*\n.*?\n?)^(---\s*$\n?)/m

    class Cache
      def initialize(cache_dir)
        @store = PStore.new(File.join(cache_dir, "nanoc-github.store"), true)
      end

      def write(name, value, options = nil)
        store.transaction { store[name] = value }
      end

      def read(name, options = nil)
        store.transaction(true) { store[name] }
      end

      def delete(name, options = nil)
        store.transaction { store.delete(name) }
      end

      private
      attr_reader :store
    end

    class ModifyMaxAge < Faraday::Middleware
      def initialize(app, time:)
        @app  = app
        @time = Integer(time)
      end

      def call(request_env)
        @app.call(request_env).on_complete do |response_env|
          response_env[:response_headers][:cache_control] = "public, max-age=#{@time}, s-maxage=#{@time}"
        end
      end
    end

    class Source < Nanoc::DataSource
      identifier :github

      def up
        stack = Faraday::RackBuilder.new do |builder|
          builder.use ModifyMaxAge, time: max_age
          builder.use Faraday::HttpCache,
            serializer: Marshal,
            shared_cache: false,
            store: Cache.new(tmp_dir),
            logger: verbose ? logger : nil
          builder.use Faraday::Request::Retry,
            exceptions: [Octokit::ServerError]
          builder.use Octokit::Middleware::FollowRedirects
          builder.use Octokit::Response::RaiseError
          builder.use Octokit::Response::FeedParser
          builder.adapter Faraday.default_adapter
        end
        Octokit.middleware = stack
      end

      def items
        @items ||= begin
          repository_items.map do |item|
            identifier     = Nanoc::Identifier.new("/#{item[:name]}")
            metadata, data = decode(item[:content])

            new_item(data, metadata, identifier, checksum_data: item[:sha])
          end
        end
      end

      private

      def client
        Octokit::Client.new(access_token: access_token)
      end

      def decode(content)
        content   = Base64.decode64(content).force_encoding(encoding)
        matchdata = content.match(REGEX)
        metadata  = matchdata ? YAML.safe_load(matchdata[:metadata], permitted_classes: [Time]) : {}

        [metadata, content.gsub(REGEX, '')]
      end

      def repository_items
        pool  = Concurrent::FixedThreadPool.new(concurrency)
        items = Concurrent::Array.new
          client
            .contents(repository, path: path)
            .select { |item| item[:type] == "file" }
            .each   { |item| pool.post { items << client.contents(repository, path: item[:path]) } }
        pool.shutdown
        pool.wait_for_termination
        items
      rescue Octokit::NotFound => exc
        []
      end

      def encoding
        @config[:encoding] || "utf-8"
      end

      def concurrency
        @config[:concurrency] || 5
      end

      def access_token
        @config[:access_token]
      end

      def path
        @config[:path]
      end

      def repository
        @config[:repository]
      end

      def verbose
        @config[:verbose]
      end

      def max_age
        @config[:max_age] || 60
      end

      def logger
        Logger.new(STDOUT)
      end

      def tmp_dir
        File.join(@site_config.dir, "tmp")
      end
    end
  end
end
