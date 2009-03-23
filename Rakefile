require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('things-rb', '0.1.1') do |p|
  p.description = "Library and command-line tool for accessing Things.app databases"
  p.url         = "http://github.com/haraldmartin/things-rb"
  p.author      = "Martin Ström"
  p.email       = "martin.strom@gmail.com"
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
