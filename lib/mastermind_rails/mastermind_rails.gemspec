$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mastermind_rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mastermind_rails"
  s.version     = MastermindRails::VERSION
  s.authors     = ["Oreoluwa Akinniranye"]
  s.email       = ["oreoluwa.akinniranye@andela.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of MastermindRails."
  s.description = "TODO: Description of MastermindRails."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.3"

  s.add_development_dependency "sqlite3"
end
