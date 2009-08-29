# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{things-rb}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Martin Str\303\266m"]
  s.date = %q{2009-08-29}
  s.default_executable = %q{things}
  s.description = %q{Library and command-line tool for accessing Things.app databases}
  s.email = %q{martin.strom@gmail.com}
  s.executables = ["things"]
  s.extra_rdoc_files = ["bin/things", "CHANGELOG", "lib/things/document.rb", "lib/things/focus.rb", "lib/things/task.rb", "lib/things/version.rb", "lib/things.rb", "LICENSE", "README.markdown"]
  s.files = ["bin/things", "CHANGELOG", "lib/things/document.rb", "lib/things/focus.rb", "lib/things/task.rb", "lib/things/version.rb", "lib/things.rb", "LICENSE", "Manifest", "Rakefile", "README.markdown", "test/fixtures/Database.xml", "test/test_document.rb", "test/test_focus.rb", "test/test_helper.rb", "test/test_task.rb", "things-rb.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/haraldmartin/things-rb}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Things-rb", "--main", "README.markdown"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{things-rb}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Library and command-line tool for accessing Things.app databases}
  s.test_files = ["test/test_document.rb", "test/test_focus.rb", "test/test_helper.rb", "test/test_task.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
