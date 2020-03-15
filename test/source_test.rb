require_relative "test_helper"

module Nanoc
  module Github
    class SourceTest < Minitest::Test
      def site_config
        Nanoc::Core::Configuration.new(hash: {}, dir: '/dummy')
      end

      def source
        Source.new(site_config, nil, nil, repository: 'pawelpacana/test-source')
      end

      def test_identifier
        assert_equal :github, source.class.identifier
      end

      def test_items
        assert_kind_of Array, source.items
        refute source.items.empty?
      end

      def test_item
        item = source.items[0]

        assert_kind_of Nanoc::Core::Item, item
        assert_equal Nanoc::Identifier.new("/post.md"), item.identifier
        assert_equal <<~EOC, item.content.string
          # Title

          Some content.
        EOC
        assert_equal ({}), item.attributes
      end
    end
  end
end
