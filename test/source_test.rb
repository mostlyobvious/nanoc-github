require_relative "test_helper"

module Nanoc
  module Github
    class SourceTest < Minitest::Test
      def site_config
        Nanoc::Core::Configuration.new(hash: {}, dir: "/dummy")
      end

      def source_with_posts
        Source.new(site_config, nil, nil, {
          repository:   "pawelpacana/test-source",
          path:         "posts",
          encoding:     "utf-8",
          concurrency:  1,
        })
      end

      def source_with_concurrency
        Source.new(site_config, nil, nil, {
          repository:   "pawelpacana/test-source",
          path:         "posts",
          encoding:     "utf-8",
          concurrency:  2,
        })
      end

      def empty_source
        Source.new(site_config, nil, nil, {
          repository:   "pawelpacana/test-empty",
          concurrency:  1,
        })
      end

      def empty_source_by_path
        Source.new(site_config, nil, nil, {
          repository:   "pawelpacana/test-source",
          path:         "dummy",
          concurrency:  1,
        })
      end

      def flat_source
        Source.new(site_config, nil, nil, {
          repository:   "pawelpacana/test-source",
          concurrency:  1
        })
      end

      def source_with_token
        Source.new(site_config, nil, nil, {
          repository:   "pawelpacana/test-source",
          path:         "posts",
          access_token: "secret123",
          concurrency:  1,
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

      def post_body
        {
          name: "post.md",
          path: "posts/post.md",
          sha: "3c612584217e21ae00d532a86e0e35685131dbba",
          size: 23,
          url: "https://api.github.com/repos/pawelpacana/test-source/contents/posts/post.md?ref=master",
          html_url: "https://github.com/pawelpacana/test-source/blob/master/posts/post.md",
          git_url: "https://api.github.com/repos/pawelpacana/test-source/git/blobs/3c612584217e21ae00d532a86e0e35685131dbba",
          download_url: "https://raw.githubusercontent.com/pawelpacana/test-source/master/posts/post.md",
          type: "file",
          content: "IyBUaXRsZQoKU29tZSBjb250ZW50Lgo=\n",
          encoding: "base64",
          _links: {
            self: "https://api.github.com/repos/pawelpacana/test-source/contents/posts/post.md?ref=master",
            git: "https://api.github.com/repos/pawelpacana/test-source/git/blobs/3c612584217e21ae00d532a86e0e35685131dbba",
            html: "https://github.com/pawelpacana/test-source/blob/master/posts/post.md"
          }
        }
      end

      def x_post_body
        {
          name: "x-post.md",
          path: "posts/x-post.md",
          sha: "34773833eda5caf2352a1ab8c1ba34e246ab9554",
          size: 150,
          url: "https://api.github.com/repos/pawelpacana/test-source/contents/posts/x-post.md?ref=master",
          html_url: "https://github.com/pawelpacana/test-source/blob/master/posts/x-post.md",
          git_url: "https://api.github.com/repos/pawelpacana/test-source/git/blobs/34773833eda5caf2352a1ab8c1ba34e246ab9554",
          download_url: "https://raw.githubusercontent.com/pawelpacana/test-source/master/posts/x-post.md",
          type: "file",
          content: "LS0tCnB1Ymxpc2hlZF9hdDogMTk3MC0wMS0wMSAwMTowMDowMCArMDEwMAp0\nYWdzOiBbJ29uZScsICdicmlkZ2UnLCAndG9vJywgJ2ZhciddCmF1dGhvcjog\nSmFuIE1hcmlhCi0tLQoKIyBXaGF0IHdoYXQKClphxbzDs8WCxIcgZ8SZxZts\nxIUgamHFusWEIPCfmYgK\n",
          encoding: "base64",
          _links: {
            self: "https://api.github.com/repos/pawelpacana/test-source/contents/posts/x-post.md?ref=master",
            git: "https://api.github.com/repos/pawelpacana/test-source/git/blobs/34773833eda5caf2352a1ab8c1ba34e246ab9554",
            html: "https://github.com/pawelpacana/test-source/blob/master/posts/x-post.md"
          }
        }
      end

      def posts_body
        [
          {
            name: "post.md",
            path: "posts/post.md",
            sha: "3c612584217e21ae00d532a86e0e35685131dbba",
            size: 23,
            url: "https://api.github.com/repos/pawelpacana/test-source/contents/posts/post.md?ref=master",
            html_url: "https://github.com/pawelpacana/test-source/blob/master/posts/post.md",
            git_url: "https://api.github.com/repos/pawelpacana/test-source/git/blobs/3c612584217e21ae00d532a86e0e35685131dbba",
            download_url: "https://raw.githubusercontent.com/pawelpacana/test-source/master/posts/post.md",
            type: "file",
            _links: {
              self: "https://api.github.com/repos/pawelpacana/test-source/contents/posts/post.md?ref=master",
              git: "https://api.github.com/repos/pawelpacana/test-source/git/blobs/3c612584217e21ae00d532a86e0e35685131dbba",
              html: "https://github.com/pawelpacana/test-source/blob/master/posts/post.md"
            }
          },
          {
            name: "x-post.md",
            path: "posts/x-post.md",
            sha: "34773833eda5caf2352a1ab8c1ba34e246ab9554",
            size: 150,
            url: "https://api.github.com/repos/pawelpacana/test-source/contents/posts/x-post.md?ref=master",
            html_url: "https://github.com/pawelpacana/test-source/blob/master/posts/x-post.md",
            git_url: "https://api.github.com/repos/pawelpacana/test-source/git/blobs/34773833eda5caf2352a1ab8c1ba34e246ab9554",
            download_url: "https://raw.githubusercontent.com/pawelpacana/test-source/master/posts/x-post.md",
            type: "file",
            _links: {
              self: "https://api.github.com/repos/pawelpacana/test-source/contents/posts/x-post.md?ref=master",
              git: "https://api.github.com/repos/pawelpacana/test-source/git/blobs/34773833eda5caf2352a1ab8c1ba34e246ab9554",
              html: "https://github.com/pawelpacana/test-source/blob/master/posts/x-post.md"
            }
          }
        ]
      end

      def json_response(body)
        { status: 200, body: JSON.dump(body), headers: { CONTENT_TYPE: 'application/json' } }
      end

      def test_items_out_of_order
        VCR.turn_off!
        stub_request(:get, "https://api.github.com/repos/pawelpacana/test-source/contents/posts")
          .to_return { json_response(posts_body) }
        stub_request(:get, "https://api.github.com/repos/pawelpacana/test-source/contents/posts/x-post.md")
          .to_return { json_response(x_post_body) }
        stub_request(:get, "https://api.github.com/repos/pawelpacana/test-source/contents/posts/post.md")
          .to_return { sleep(0.1); json_response(post_body) }


        items = source_with_concurrency.items
        assert_equal items, items.sort_by { |item| item.identifier }
      ensure
        VCR.turn_on!
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
    end
  end
end
