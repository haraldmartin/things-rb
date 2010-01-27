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
      @xml_node.at("attribute[@name='title']").inner_text
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
        @doc.at("##{tag_id} attribute[@name=title]").inner_text
      end
    end

    def tags?
      tags.any?
    end
    
    def tag?(name)
      tags.include?(name)
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
      @notes ||= (node = @xml_node.at("attribute[@name='content']")) &&
        Hpricot.parse(node.inner_text.gsub(/\\u3c00/, "<").gsub(/\\u3e00/, ">")).inner_text
    end
    
    def notes?
      !!notes
    end
    
    def status
      @status ||= (node = @xml_node.at("attribute[@name='status']")) && node.inner_text.to_i
    end
    
    def position
      @position ||= @xml_node.at("attribute[@name='index']").inner_text.to_i
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
    
    private
    
    def tasks_from_ids(ids)
      ids.map { |id| task_from_id(id) }.compact
    end
    
    def task_from_id(id)
      if (node = @doc.at("##{id}")) && node.inner_text.strip != ''
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
      if node = @xml_node.at("relationship[@name='#{name}'][@idrefs]")
        node.attributes['idrefs'].split
      else
        []
      end
    end
  
    def date_attribute(name)
      (node = @xml_node.at("attribute[@name='#{name}']")) && node.inner_text.to_f.to_cocoa_date
    end
  end
end
