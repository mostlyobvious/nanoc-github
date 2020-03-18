# frozen_string_literal: true

require_relative "lib/nanoc/github/version"

Gem::Specification.new do |spec|
  spec.name          = "nanoc-github"
  spec.version       = Nanoc::Github::VERSION
  spec.summary       = "Nanoc content source from git repository"
  spec.description   = <<~DESC
    Nanoc content source from git repository. A way to have your writing in public and open for edition while not being
    distracted by static site generator trivia this content is usually mixed with.
  DESC
  spec.authors       = ["Paweł Pacana"]
  spec.license       = "MIT"
  spec.email         = ["pawel.pacana@gmail.com"]
  spec.homepage      = "https://github.com/pawelpacana/nanoc-github"
  spec.metadata      = {
    "homepage_uri"    => spec.homepage,
    "source_code_uri" => "https://github.com/pawelpacana/nanoc-github",
    "changelog_uri"   => "https://github.com/pawelpacana/nanoc-github/releases",
    "bug_tracker_uri" => "https://github.com/pawelpacana/nanoc-github/issues"
  }
  spec.files         = Dir.glob("lib/**/*")
  spec.require_paths = ["lib"]
  spec.extra_rdoc_files = Dir["README.md", "LICENSE.txt"]

  spec.add_dependency "nanoc",           "~> 4.0"
  spec.add_dependency "octokit",         "~> 4.0"
  spec.add_dependency "concurrent-ruby", ">= 1.1.6", "< 2.0"
end
