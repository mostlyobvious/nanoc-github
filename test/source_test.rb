require_relative "test_helper"

module Nanoc
  module Github
    class SourceTest < Minitest::Test
      def site_config
        Nanoc::Core::Configuration.new(hash: {}, dir: '/dummy')
      end

      def source
        Source.new(site_config, nil, nil, nil)
      end

      def test_identifier
        assert_equal :github, source.class.identifier
      end
    end
  end
end
