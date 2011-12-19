module Things
  class Focus
    FOCUS_TYPES = %w[FocusInbox FocusLogbook FocusMaybe FocusNextActions FocusTickler FocusToday FocusTrash].freeze
    
    def initialize(name, doc)
      @name     = name
      @doc      = doc
      @xml_node = @doc.at_xpath("//object[@type='FOCUS']/attribute[@name='identifier'][text()='#{type_name}']/..")
    end
    
    def type_name
      name = case @name.to_s
        when /next/i            then "FocusNextActions"
        when "someday", "later" then "FocusMaybe"
        when "scheduled"        then "FocusTickler"
        else "Focus" + @name.to_s.capitalize
      end
      raise Things::InvalidFocus, name unless FOCUS_TYPES.member?(name)
      name
    end

    def id
      @id ||= @xml_node.attributes['id'].value
    end

    def type_id
      @type_id ||= @xml_node.at_xpath('attribute[@name=\'focustype\']').inner_text
    end
    
    def tasks(options = {})
      options ||= {} # when options == nil
      
      selector = "//object[@type='TODO']/attribute[@name='focustype'][text()='#{type_id}']/.."
      
      # Non-recurring scheduled tasks have different type_id's (16842752).
      # FocusTickler's type_id is for recurring scheduled.
      if @name.to_s == 'scheduled'
        selector = "//object[@type='TODO']/attribute[@name='focustype'][text()='#{type_id}' or text()='16842752']/.."
      end
      
      @all_tasks ||= @doc.search(selector).map do |task_xml|
        Task.new(task_xml, @doc)
      end

      filter_tasks!(options)
      
      @tasks.sort_by &:position
    end
    
    alias_method :todos, :tasks
    
    private
    
    # TODO: Smarter task filtering
    def filter_tasks!(options)
      @tasks = @all_tasks.reject(&:children?)

      [:completed, :canceled].each do |filter|
        proc = Proc.new { |e| e.send("#{filter}?") }
        if options.key?(filter)
          if options[filter]
            @tasks = @tasks.select(&proc)
          else
            @tasks = @tasks.reject(&proc)
          end
        end
      end
            
      if tag = options[:tag]
        @tasks = @tasks.select { |t| t.tag?(tag) }
      end
    end
  end
end