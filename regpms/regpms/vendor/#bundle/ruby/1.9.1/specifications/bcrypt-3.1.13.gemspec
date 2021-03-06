# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "bcrypt"
  s.version = "3.1.13"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Coda Hale"]
  s.date = "2019-05-31"
  s.description = "    bcrypt() is a sophisticated and secure hash algorithm designed by The OpenBSD project\n    for hashing passwords. The bcrypt Ruby gem provides a simple wrapper for safely handling\n    passwords.\n"
  s.email = "coda.hale@gmail.com"
  s.extensions = ["ext/mri/extconf.rb"]
  s.extra_rdoc_files = ["README.md", "COPYING", "CHANGELOG", "lib/bcrypt.rb", "lib/bcrypt/password.rb", "lib/bcrypt/engine.rb", "lib/bcrypt/error.rb"]
  s.files = ["README.md", "COPYING", "CHANGELOG", "lib/bcrypt.rb", "lib/bcrypt/password.rb", "lib/bcrypt/engine.rb", "lib/bcrypt/error.rb", "ext/mri/extconf.rb"]
  s.homepage = "https://github.com/codahale/bcrypt-ruby"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--title", "bcrypt-ruby", "--line-numbers", "--inline-source", "--main", "README.md"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.23.2"
  s.summary = "OpenBSD's bcrypt() password hashing algorithm."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake-compiler>, ["~> 0.9.2"])
      s.add_development_dependency(%q<rspec>, [">= 3"])
    else
      s.add_dependency(%q<rake-compiler>, ["~> 0.9.2"])
      s.add_dependency(%q<rspec>, [">= 3"])
    end
  else
    s.add_dependency(%q<rake-compiler>, ["~> 0.9.2"])
    s.add_dependency(%q<rspec>, [">= 3"])
  end
end
