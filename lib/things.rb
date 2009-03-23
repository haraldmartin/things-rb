$:.unshift File.dirname(__FILE__)

require "rubygems"
require "hpricot"

# temp#######
# require '/Users/martin/Code/rails/head/activesupport/lib/active_support/core_ext/module/attribute_accessors'

class Symbol
  def to_proc
    Proc.new { |obj, *args| obj.send(self, *args) }
  end
end

require 'things/version'
require 'things/document'
require 'things/focus'
require 'things/task'

module Things
  class FocusNotFound < StandardError; end
  class InvalidFocus < StandardError; end
  
  def Things.new(*options)
    Document.new(*options)
  end
end