# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "xpath"
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jonas Nicklas"]
  s.date = "2012-11-14"
  s.description = "XPath is a Ruby DSL for generating XPath expressions"
  s.email = ["jonas.nicklas@gmail.com"]
  s.extra_rdoc_files = ["README.md"]
  s.files = ["README.md"]
  s.homepage = "http://github.com/jnicklas/xpath"
  s.rdoc_options = ["--main", "README.md"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "xpath"
  s.rubygems_version = "1.8.11"
  s.summary = "Generate XPath expressions from Ruby"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, ["~> 1.3"])
      s.add_development_dependency(%q<rspec>, ["~> 2.0"])
      s.add_development_dependency(%q<yard>, [">= 0.5.8"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<nokogiri>, ["~> 1.3"])
      s.add_dependency(%q<rspec>, ["~> 2.0"])
      s.add_dependency(%q<yard>, [">= 0.5.8"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<nokogiri>, ["~> 1.3"])
    s.add_dependency(%q<rspec>, ["~> 2.0"])
    s.add_dependency(%q<yard>, [">= 0.5.8"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
