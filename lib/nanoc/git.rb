require "nanoc/git/version"
require "nanoc"
require "octokit"
require "front_matter_parser"

# GITHUB_TOKEN i.e. 40-char string from https://github.com/settings/tokens
# GITHUB_REPO  i.e. arkency/blog.arkency.com

module Nanoc
  module Git
    class Error < StandardError; end

    class Source < Nanoc::DataSource
      identifier :git

      def items
        client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
        client
          .contents(ENV['GITHUB_REPO'])
          .select { |item| item.end_with?(".md") }
          .map    { |item| client.contents(ENV['GITHUB_REPO'], path: item[:path]) }
          .map    { |item| new_item(content = item[:content], parse_frontmatter(content), Nanoc::Identifier.new(item[:path])) }
      end

      def parse_frontmatter(content)
        FrontMatterParser::Parser.new(:md).call(content).front_matter
      end
    end
  end
end
