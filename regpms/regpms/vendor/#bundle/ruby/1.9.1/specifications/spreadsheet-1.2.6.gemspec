# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "spreadsheet"
  s.version = "1.2.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Hannes F. Wyss, Masaomi Hatakeyama, Zeno R.R. Davatz"]
  s.date = "2020-01-22"
  s.description = "The Spreadsheet Library is designed to read and write Spreadsheet Documents.\nAs of version 0.6.0, only Microsoft Excel compatible spreadsheets are\nsupported. Spreadsheet is a combination/complete rewrite of the\nSpreadsheet::Excel Library by Daniel J. Berger and the ParseExcel Library by\nHannes Wyss. Spreadsheet can read, write and modify Spreadsheet Documents."
  s.email = "zdavatz@ywesee.com"
  s.executables = ["xlsopcodes"]
  s.extra_rdoc_files = ["GUIDE.md", "History.md", "LICENSE.txt", "Manifest.txt", "README.md"]
  s.files = ["bin/xlsopcodes", "GUIDE.md", "History.md", "LICENSE.txt", "Manifest.txt", "README.md"]
  s.homepage = "https://github.com/zdavatz/spreadsheet"
  s.licenses = ["GPL-3.0"]
  s.rdoc_options = ["--main", "README.md"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.23.2"
  s.summary = "The Spreadsheet Library is designed to read and write Spreadsheet Documents"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ruby-ole>, [">= 1.0"])
      s.add_development_dependency(%q<rdoc>, ["< 7", ">= 4.0"])
      s.add_development_dependency(%q<hoe>, ["~> 3.17"])
    else
      s.add_dependency(%q<ruby-ole>, [">= 1.0"])
      s.add_dependency(%q<rdoc>, ["< 7", ">= 4.0"])
      s.add_dependency(%q<hoe>, ["~> 3.17"])
    end
  else
    s.add_dependency(%q<ruby-ole>, [">= 1.0"])
    s.add_dependency(%q<rdoc>, ["< 7", ">= 4.0"])
    s.add_dependency(%q<hoe>, ["~> 3.17"])
  end
end
