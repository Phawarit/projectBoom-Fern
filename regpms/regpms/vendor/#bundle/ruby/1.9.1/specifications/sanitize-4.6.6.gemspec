# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "sanitize"
  s.version = "4.6.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2.0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ryan Grove"]
  s.date = "2018-07-24"
  s.description = "Sanitize is a whitelist-based HTML and CSS sanitizer. Given a list of acceptable elements, attributes, and CSS properties, Sanitize will remove all unacceptable HTML and/or CSS from a string."
  s.email = "ryan@wonko.com"
  s.homepage = "https://github.com/rgrove/sanitize/"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.rubygems_version = "1.8.23.2"
  s.summary = "Whitelist-based HTML and CSS sanitizer."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<crass>, ["~> 1.0.2"])
      s.add_runtime_dependency(%q<nokogiri>, [">= 1.4.4"])
      s.add_runtime_dependency(%q<nokogumbo>, ["~> 1.4"])
      s.add_development_dependency(%q<minitest>, ["~> 5.10.2"])
      s.add_development_dependency(%q<rake>, ["~> 12.0.0"])
    else
      s.add_dependency(%q<crass>, ["~> 1.0.2"])
      s.add_dependency(%q<nokogiri>, [">= 1.4.4"])
      s.add_dependency(%q<nokogumbo>, ["~> 1.4"])
      s.add_dependency(%q<minitest>, ["~> 5.10.2"])
      s.add_dependency(%q<rake>, ["~> 12.0.0"])
    end
  else
    s.add_dependency(%q<crass>, ["~> 1.0.2"])
    s.add_dependency(%q<nokogiri>, [">= 1.4.4"])
    s.add_dependency(%q<nokogumbo>, ["~> 1.4"])
    s.add_dependency(%q<minitest>, ["~> 5.10.2"])
    s.add_dependency(%q<rake>, ["~> 12.0.0"])
  end
end
