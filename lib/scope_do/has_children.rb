# vim:set fileencoding=utf-8 filetype=ruby

module ScopeDo
  module HasChildren
    def self.included(base)
      base.extend ClassMethods
    end
  end

  class QueryBuilder
    def self.has_children_condition(n, q)
      select_cols, rest = q
      if n
      "#{n} <= (SELECT COUNT(#{select_cols}) #{rest})"
      else
        "EXISTS(SELECT #{select_cols} #{rest})"
      end
    end

    def initialize(base, association)
      @base = base
      @association = association
    end

    def has_children_query_parts
      if through = @association.through_reflection
        query_parts(@base, through)
      else
        query_parts(@base, @association)
      end
    end

    private
    def query_parts(parent, association)
      child_t = association.quoted_table_name
      parent_t = parent.quoted_table_name
      [
        "#{child_t}.#{association.primary_key_name}",
        "FROM #{child_t} WHERE #{parent_t}.#{parent.primary_key} = #{child_t}.#{association.primary_key_name}"
      ]
    end
  end

  module ClassMethods
    def has_children(target)
      association = reflections[target]
      builder = QueryBuilder.new(self, association)
      qs = builder.has_children_query_parts

      named_scope "has_#{target}", proc{|*n|
        {:conditions => QueryBuilder.has_children_condition(n.shift, qs)}
      }
    end
  end
end

