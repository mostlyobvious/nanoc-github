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
          .select { |item| item[:path].end_with?(".md") }
          .map    { |item| client.contents(ENV['GITHUB_REPO'], path: item[:path]) }
          .map    { |item| new_item(content = decode_content(item[:content]), parse_frontmatter(content), Nanoc::Identifier.new("/#{item[:path]}")) }
      end

      def decode_content(encoded)
        Base64.decode64(encoded).force_encoding(Encoding::UTF_8)
      end

      def parse_frontmatter(content)
        FrontMatterParser::Loader::Yaml.new(whitelist_classes: [Time, Symbol]).call(
          FrontMatterParser::SyntaxParser::Md.new.call(content)[:front_matter])
      end
    end
  end
end
