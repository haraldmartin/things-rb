# -*- encoding: utf-8 -*-
require "rubygems"
require "rake/testtask"

task :default => :test

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/test_*.rb"]
  t.verbose = true
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name        = "things-rb"
    gemspec.summary     = "Library and command-line tool for accessing Things.app databases"
    gemspec.description = "Library and command-line tool for accessing Things.app databases"
    gemspec.email       = "name@my-domain.se"
    gemspec.homepage    = "http://github.com/haraldmartin/things-rb"
    gemspec.authors     = ["Martin Ström"]
    gemspec.add_dependency 'hpricot'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end
