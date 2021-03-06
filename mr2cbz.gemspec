# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mr2cbz/version"

Gem::Specification.new do |s|
  s.name        = "mr2cbz"
  s.version     = Mr2cbz::VERSION
  s.authors     = ["Alessio Caiazza"]
  s.email       = ["nolith@abisso.org"]
  s.homepage    = "https://github.com/nolith/mr2cbz"
  s.summary     = %q{From mangareader.net to CBZ}
  s.description = %q{Downloads manga from mangareder.net in CBZ format}

  s.rubyforge_project = "mr2cbz"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_development_dependency 'rake'
  s.add_runtime_dependency 'mechanize'
  s.add_runtime_dependency 'thor'
end
