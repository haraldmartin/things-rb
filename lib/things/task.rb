# -*- encoding: utf-8 -*-
module Things
  class Task
    include Comparable
    
    INCOMPLETED = 0
    CANCELED    = 2
    COMPLETED   = 3
    CHECK_MARK  = "✓"
    X_MARK      = "×"
    MINUS_MARK  = "-"
    
    def initialize(task_xml, doc)
      @doc      = doc
      @xml_node = task_xml
    end

    def title
      @xml_node.at_xpath("attribute[@name='title']").inner_text
    end

    alias_method :to_s, :title

    def <=>(another)
      if parent? && another.parent?
        parent <=> another.parent
      else
        title <=> another.title
      end
    end

    def to_xml
      @xml_node.to_s
    end
  
    def tag_ids
      ids_from_relationship("tags")
    end

    def tags
      @tags ||= tag_ids.map do |tag_id|
        @doc.at_xpath("//object[@type='TAG'][@id='#{tag_id}']/attribute[@name='title']").inner_text
      end
    end

    def tags?
      tags.any?
    end
    
    def tag?(name)
      tags.any? { |t| t.casecmp(name) == 0 }
    end
    
    def parent_id
      id_from_relationship('parent')
    end

    def parent
      @parent ||= task_from_id(parent_id)
    end

    def parent?
      !!parent
    end

    def completed?
      status == COMPLETED
    end

    alias_method :complete?, :completed?
    alias_method :done?, :completed?

    def incompleted?
      status == INCOMPLETED
    end

    alias_method :incomplete?, :incompleted?
    
    def canceled?
      status == CANCELED
    end
    
    def notes
      @notes ||= (node = @xml_node.at_xpath("attribute[@name='content']")) &&
        Nokogiri::XML.parse(node.inner_text.gsub(/\\u3c00/, "<").gsub(/\\u3e00/, ">")).inner_text
    end
    
    def notes?
      !!notes
    end
    
    def status
      @status ||= (node = @xml_node.at_xpath("attribute[@name='status']")) && node.inner_text.to_i
    end
    
    def position
      @position ||= @xml_node.at_xpath("attribute[@name='index']").inner_text.to_i
    end
    
    alias_method :index, :position
    alias_method :order, :position
    
    def due_date
      @due_date ||= date_attribute("datedue")
    end

    def due?
      !!due_date && Time.now > due_date
    end

    def scheduled_date
      @scheduled_date ||= date_attribute('tickledate')
    end
    
    def scheduled?
      !!scheduled_date
    end

    def bullet
      case
      when completed?
        CHECK_MARK
      when canceled?
        X_MARK
      else
        MINUS_MARK
      end
    end

    def children_ids
      ids_from_relationship('children')
    end
    
    def children
      @children ||= tasks_from_ids(children_ids)
    end
    
    def children?
      children.any?
    end
    
    # If the task referrences a recurrence rule. Instances will not be identified as recurring?
    def recurring?
      !!@xml_node.at_xpath("attribute[@name='recurrenceruledata']")
    end
    
    def focus_level
      node = @xml_node.at_xpath("attribute[@name='focuslevel']")
      node.inner_text.to_i
    end
    
    def area_of_responsibility
      return unless parent?
      
      # Parent is an Area of Responsibility
      if parent.focus_level == 2
        parent.title
      # Parent is a Project, but may belong to an Area of Resp.
      elsif parent.focus_level == 1 &&
            parent.parent &&
            parent.parent.focus_level == 2
        parent.parent.title
      end
    end
    
    private
    
    def tasks_from_ids(ids)
      ids.map { |id| task_from_id(id) }.compact
    end
    
    def task_from_id(id)
      if node = @doc.at_xpath("//object[@type='TODO'][@id='#{id}']")
        Task.new(node, @doc)
      else
        nil
      end
    end
  
    # TODO rename id_from_relationship
    def id_from_relationship(name)
      ids_from_relationship(name)[0]
    end
    
    def ids_from_relationship(name)
      if node = @xml_node.at_xpath("relationship[@name='#{name}'][@idrefs]")
        node.attributes['idrefs'].value.split
      else
        []
      end
    end
  
    def date_attribute(name)
      (node = @xml_node.at_xpath("attribute[@name='#{name}']")) && node.inner_text.to_f.to_cocoa_date
    end
  end
end
