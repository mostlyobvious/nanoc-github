require "nanoc/git/version"
require "nanoc"

module Nanoc
  module Git
    class Error < StandardError; end

    class Source < Nanoc::DataSource
      identifier :git

      def items
        []
      end
    end
  end
end
