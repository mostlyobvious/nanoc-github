require "nanoc"
require "octokit"


module Nanoc
  module Github
    Error = Class.new(StandardError)

    class Source < Nanoc::DataSource
      identifier :github

      def items
        repository_items.map do |item|
          identifier = Nanoc::Identifier.new("/#{item[:path]}")
          new_item(decode(item[:content]), {}, identifier)
        end
      end

      private

      def client
        Octokit::Client.new
      end

      def decode(content)
        Base64.decode64(content)
      end

      def repository_items
        client.contents(repository).map do |item|
          client.contents(repository, path: item[:path])
        end
      end

      def repository
        @config[:repository]
      end
    end
  end
end
