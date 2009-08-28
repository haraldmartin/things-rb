module Things
  class Document
    DEFAULT_DATABASE_PATH = ENV['HOME'] + '/Library/Application Support/Cultured Code/Things/Database.xml' unless defined?(DEFAULT_DATABASE_PATH)
    
    attr_reader :database_file
  
    def initialize(options = {}, &block)
      @database_file = options[:database] || DEFAULT_DATABASE_PATH
      @focus_cache = {}
      parse!
      yield self if block_given?
    end
  
    def database
      @doc
    end
    
    def focus(name)
      @focus_cache[name] ||= Focus.new(name, @doc)
    end
  
    [:today, :inbox, :trash, :logbook, :next, :scheduled].each do |name|
      class_eval <<-EOF
        def #{name}(options = {})               # def inbox(options = {})
          focus(:#{name}).tasks(options)        #   focus(:inbox).tasks(options)
        end                                     # end
      EOF
    end
    
    alias_method :nextactions, :next
    alias_method :next_actions, :next
  
    private

    def parse!
      @doc = Hpricot(IO.read(database_file))
    end
  end
end