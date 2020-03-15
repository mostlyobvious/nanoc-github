# frozen_string_literal: true

require_relative "lib/nanoc/git/version"

Gem::Specification.new do |spec|
  spec.name          = "nanoc-git"
  spec.version       = Nanoc::Git::VERSION
  spec.summary       = "Nanoc content source from git repository"
  spec.description   = <<~DESC
    Nanoc content source from git repository. A way to have your writing in public and open for edition while not being 
    distracted by static site generator trivia this content is usually mixed with.
  DESC
  spec.authors       = ["Paweł Pacana"]
  spec.license       = "MIT"
  spec.email         = ["pawel.pacana@gmail.com"]
  spec.homepage      = "https://github.com/pawelpacana/nanoc-git"
  spec.metadata      = {
    "homepage_uri"    => spec.homepage,
    "source_code_uri" => "https://github.com/pawelpacana/nanoc-git",
    "changelog_uri"   => "https://github.com/pawelpacana/nanoc-git/releases",
    "bug_tracker_uri" => "https://github.com/pawelpacana/nanoc-git/issues"
  }
  spec.files         = Dir.glob("lib/**/*")
  spec.require_paths = ["lib"]
  spec.extra_rdoc_files = Dir["README.md", "LICENSE.txt"]

  spec.add_dependency "nanoc",               "~> 4.0"
  spec.add_dependency "octokit",             "~> 4.0"
  spec.add_dependency "front_matter_parser", "= 0.2.1"
end
