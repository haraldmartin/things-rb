require "rubygems"
require "things"
require "test/unit"
require "mocha"

class Test::Unit::TestCase
  FIXTURES_PATH = File.expand_path(File.join(File.dirname(__FILE__), "fixtures")) unless defined?(FIXTURES_PATH)
  DATABASE_FIXTURE_PATH = File.join(FIXTURES_PATH, 'Database.xml') unless defined?(DATABASE_FIXTURE_PATH)
  
  def database_content
    IO.read(DATABASE_FIXTURE_PATH)
  end
  
  # From Rails ActiveSupport::Testing::Declarative
  def self.test(name, &block)
    test_name = "test_#{name.gsub(/\s+/,'_')}".to_sym
    defined = instance_method(test_name) rescue false
    raise "#{test_name} is already defined in #{self}" if defined
    if block_given?
      define_method(test_name, &block)
    else
      define_method(test_name) do
        flunk "No implementation provided for #{name}"
      end
    end
  end
end
