# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rtf"
  s.version = "0.3.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Peter Wood"]
  s.date = "2011-11-08"
  s.description = "Ruby RTF is a library that can be used to create rich text format (RTF) documents. RTF is a text based standard for laying out document content."
  s.email = "paw220470@yahoo.ie"
  s.extra_rdoc_files = ["LICENSE", "README.rdoc"]
  s.files = ["LICENSE", "README.rdoc"]
  s.homepage = "http://github.com/thechrisoshow/rtf"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.23.2"
  s.summary = "Ruby library to create rich text format documents."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
