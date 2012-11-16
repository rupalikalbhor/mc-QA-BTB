# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "capybara-screenshot"
  s.version = "0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matthew O'Riordan"]
  s.date = "2012-10-30"
  s.description = "When a Cucumber step fails, it is useful to create a screenshot image and HTML file of the current page"
  s.email = ["matthew.oriordan@gmail.com"]
  s.homepage = "http://github.com/mattheworiordan/capybara-screenshot"
  s.require_paths = ["lib"]
  s.rubyforge_project = "capybara-screenshot"
  s.rubygems_version = "1.8.11"
  s.summary = "Automatically create snapshots when Cucumber steps fail with Capybara and Rails"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<capybara>, [">= 1.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.7"])
      s.add_development_dependency(%q<timecop>, [">= 0"])
    else
      s.add_dependency(%q<capybara>, [">= 1.0"])
      s.add_dependency(%q<rspec>, ["~> 2.7"])
      s.add_dependency(%q<timecop>, [">= 0"])
    end
  else
    s.add_dependency(%q<capybara>, [">= 1.0"])
    s.add_dependency(%q<rspec>, ["~> 2.7"])
    s.add_dependency(%q<timecop>, [">= 0"])
  end
end
