# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "magic_encoding"
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ["Manuel Ryan"]
  s.date = "2010-08-02"
  s.email = ["ryan@shamu.ch"]
  s.executables = ["magic_encoding"]
  s.files = ["bin/magic_encoding"]
  s.homepage = "http://github.com/m-ryan/magic_encoding"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.11"
  s.summary = "Easily add magic comments for encoding on multiple ruby source files"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
