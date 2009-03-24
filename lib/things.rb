$:.unshift File.dirname(__FILE__)

require "rubygems"
require "hpricot"

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
  
  def Things.new(*options, &block)
    Document.new(*options, &block)
  end
end