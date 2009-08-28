$:.unshift File.dirname(__FILE__)

require "rubygems"
require "hpricot"
require "time"

class Symbol
  def to_proc
    Proc.new { |obj, *args| obj.send(self, *args) }
  end
end

class Float
  EPOCH = Time.at(978307200.0)

  def to_cocoa_date
    EPOCH + self
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