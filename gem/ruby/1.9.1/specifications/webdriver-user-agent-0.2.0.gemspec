# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "webdriver-user-agent"
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alister Scott"]
  s.date = "2012-09-20"
  s.description = "A helper gem to emulate populate device user agents and resolutions when using webdriver"
  s.email = ["alister.scott@gmail.com"]
  s.homepage = "https://github.com/alisterscott/webdriver-user-agent"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.11"
  s.summary = "A helper gem to emulate populate device user agents and resolutions when using webdriver"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<selenium-webdriver>, [">= 0"])
      s.add_runtime_dependency(%q<facets>, [">= 0"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<watir-webdriver>, [">= 0"])
    else
      s.add_dependency(%q<selenium-webdriver>, [">= 0"])
      s.add_dependency(%q<facets>, [">= 0"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<watir-webdriver>, [">= 0"])
    end
  else
    s.add_dependency(%q<selenium-webdriver>, [">= 0"])
    s.add_dependency(%q<facets>, [">= 0"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<watir-webdriver>, [">= 0"])
  end
end
