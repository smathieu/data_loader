# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "data_loader/version"

Gem::Specification.new do |s|
  s.name        = "data_loader"
  s.version     = DataLoader::VERSION
  s.platform    = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.8.7'
  s.authors     = ["Nathan Youngman"]
  s.email       = ["git@nathany.com"]
  s.homepage    = "https://github.com/nathany/data_loader"
  s.summary     = %q{Loads CSV data into MySQL, doing an initial scan to determine datatypes.}
  s.description = %q{Uses fastercsv to scan a few lines of a CSV and create a schema with ActiveRecord. It does the actual file load with MySQL LOAD DATA.}
  
  s.add_dependency('fastercsv', '~> 1.5.4')
  s.add_dependency('activerecord', '~> 2.3')
  s.add_development_dependency('rspec', '~> 1.3')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
