require "nanoc"

module Nanoc
  module Github
    Error = Class.new(StandardError)

    class Source < Nanoc::DataSource
      identifier :github
    end
  end
end
