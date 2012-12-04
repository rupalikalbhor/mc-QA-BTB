# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "facets"
  s.version = "2.9.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Thomas Sawyer"]
  s.date = "2011-12-31"
  s.description = "Facets is the premier collection of extension methods for the Ruby programming language. Facets extensions are unique by virtue of thier atomicity. They are stored in individual files allowing for highly granular control of requirements. In addition, Facets includes a few additional classes and mixins suitable to wide variety of applications."
  s.email = ["transfire@gmail.com"]
  s.extra_rdoc_files = ["RUBY.txt", "HISTORY.rdoc", "README.rdoc", "NOTICE.rdoc"]
  s.files = ["RUBY.txt", "HISTORY.rdoc", "README.rdoc", "NOTICE.rdoc"]
  s.homepage = "http://rubyworks.github.com/facets"
  s.licenses = ["Ruby"]
  s.require_paths = ["lib/core", "lib/standard"]
  s.rubygems_version = "1.8.11"
  s.summary = "Premium Ruby Extensions"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<lemon>, [">= 0"])
      s.add_development_dependency(%q<qed>, [">= 0"])
      s.add_development_dependency(%q<detroit>, [">= 0"])
    else
      s.add_dependency(%q<lemon>, [">= 0"])
      s.add_dependency(%q<qed>, [">= 0"])
      s.add_dependency(%q<detroit>, [">= 0"])
    end
  else
    s.add_dependency(%q<lemon>, [">= 0"])
    s.add_dependency(%q<qed>, [">= 0"])
    s.add_dependency(%q<detroit>, [">= 0"])
  end
end
