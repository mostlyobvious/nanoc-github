
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "nanoc/git/version"

Gem::Specification.new do |spec|
  spec.name          = "nanoc-git"
  spec.version       = Nanoc::Git::VERSION
  spec.authors       = ["Paweł Pacana"]
  spec.email         = ["pawel.pacana@gmail.com"]

  spec.summary       = %q{Another Nanoc data source no one released.}
  spec.homepage      = "https://github.com/pawelpacana/nanoc-git"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/pawelpacana/nanoc-git"
    spec.metadata["changelog_uri"] = "https://github.com/pawelpacana/nanoc-git/releases"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "nanoc", "~> 4.0"
  spec.add_dependency "octokit", "~> 4.0"
  spec.add_dependency "front_matter_parser", "= 0.2.1"

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
