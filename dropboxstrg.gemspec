$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dropboxstrg/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "dropboxstrg"
  s.version     = Dropboxstrg::VERSION
  s.authors     = ["Raul Roman-Lopez"]
  s.email       = ["rroman@libresoft.es"]
  s.homepage    = "http://git.libresoft.es/%20dropboxstrg/"
  s.summary     = "Ruby plugin that installs the Dropbox driver"
  s.description = "Ruby plugin that installs the Dropbox driver for the Cloudstrg system"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.8"
  s.add_dependency "cloudstrg"

  s.add_development_dependency "sqlite3"
end
