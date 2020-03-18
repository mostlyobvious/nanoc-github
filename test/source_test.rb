require_relative "test_helper"

module Nanoc
  module Github
    class SourceTest < Minitest::Test
      def site_config
        Nanoc::Core::Configuration.new(hash: {}, dir: "/dummy")
      end

      def source_with_posts
        Source.new(site_config, nil, nil, {
          repository: "pawelpacana/test-source",
          path:       "posts"
        })
      end

      def empty_source
        Source.new(site_config, nil, nil, {
          repository: "pawelpacana/test-empty",
        })
      end

      def empty_source_by_path
        Source.new(site_config, nil, nil, {
          repository: "pawelpacana/test-source",
          path:       "dummy"
        })
      end

      def flat_source
        Source.new(site_config, nil, nil, {
          repository: "pawelpacana/test-source",
        })
      end

      def source_with_token
        Source.new(site_config, nil, nil, {
          repository:   "pawelpacana/test-source",
          path:         "posts",
          access_token: "secret123"
        })
      end

      def test_identifier
        assert_equal :github, source_with_posts.class.identifier
      end

      def test_items
        VCR.use_cassette("test_items") do
          assert_kind_of Array, source_with_posts.items
          refute source_with_posts.items.empty?
        end
      end

      def test_no_items_in_reposistory
        VCR.use_cassette("test_no_items_in_repository") do
          assert_kind_of Array, empty_source.items
          assert empty_source.items.empty?
        end
      end

      def test_no_items_in_path
        VCR.use_cassette("test_no_items_in_path") do
          assert_kind_of Array, empty_source_by_path.items
          assert empty_source_by_path.items.empty?
        end
      end

      def test_items_in_root
        VCR.use_cassette("test_items_in_root") do
          assert_kind_of Array, flat_source.items
          refute flat_source.items.empty?
        end
      end

      def test_item
        VCR.use_cassette("test_item") do
          item = source_with_posts.items[0]

          assert_kind_of Nanoc::Core::Item, item
          assert_equal Nanoc::Identifier.new("/post.md"), item.identifier
          assert_equal <<~EOC, item.content.string
            # Title

            Some content.
          EOC
          assert_equal ({}), item.attributes
          assert_equal "3c612584217e21ae00d532a86e0e35685131dbba", item.checksum_data
        end
      end

      def test_frontmatter
        VCR.use_cassette("test_frontmatter") do
          item = source_with_posts.items[1]

          assert_equal Nanoc::Identifier.new("/x-post.md"), item.identifier
          assert_equal ({
            published_at: Time.at(0),
            tags: %w(one bridge too far),
            author: "Jan Maria"
          }), item.attributes
        end
      end

      def test_utf8
        VCR.use_cassette("test_utf8") do
          item = source_with_posts.items[1]

          assert_equal Nanoc::Identifier.new("/x-post.md"), item.identifier
          assert_equal <<~EOC, item.content.string
            # What what

            Zażółć gęślą jaźń 🙈
          EOC
        end
      end

      def test_use_access_token
        stub_request(:get, "https://api.github.com/repos/pawelpacana/test-source/contents/posts")
          .with(headers: { "Authorization" => "token secret123" })
          .to_return(status: 404)
        source_with_token.items
      end

      def test_up
        assert source_with_posts.up
      end
    end
  end
end
