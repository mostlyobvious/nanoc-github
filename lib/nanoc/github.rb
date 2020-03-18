require "nanoc"
require "octokit"


module Nanoc
  module Github
    REGEX = /^(?<metadata>---\s*\n.*?\n?)^(---\s*$\n?)/m

    class Source < Nanoc::DataSource
      identifier :github

      def items
        @items ||= begin
          repository_items.map do |item|
            identifier     = Nanoc::Identifier.new("/#{item[:name]}")
            metadata, data = decode(item[:content])

            new_item(data, metadata, identifier)
          end
        end
      end

      private

      def client
        Octokit::Client.new(access_token: access_token)
      end

      def decode(content)
        content   = Base64.decode64(content).force_encoding(Encoding::UTF_8)
        matchdata = content.match(REGEX)
        metadata  = matchdata ? YAML.safe_load(matchdata[:metadata], permitted_classes: [Time]) : {}

        [metadata, content.gsub(REGEX, '')]
      end

      def repository_items
        client
          .contents(repository, path: path)
          .select { |item| item[:type] == "file" }
          .map    { |item| client.contents(repository, path: item[:path]) }
      rescue Octokit::NotFound => exc
        []
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
    end
  end
end
