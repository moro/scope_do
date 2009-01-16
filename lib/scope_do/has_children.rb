#!/usr/bin/env ruby
# vim:set fileencoding=utf-8 filetype=ruby
# $KCODE = 'u'

module ScopeDo
  module HasChildren
    def self.included(base)
      base.extend ClassMethods
    end
  end
  module ClassMethods
    def has_children(target)
      association = reflections[target]
      qs = has_children_query_parts(association)

      named_scope "has_#{target}", proc{|*n|
        {:conditions => has_children_condition(n.shift, qs)}
      }
    end

    private
    def has_children_query_parts(association)
      if through = association.through_reflection
        query_parts(self, through)
      else
        query_parts(self, association)
      end
    end

    def has_children_condition(n, q)
      select_cols, rest = q
      if n
      "#{n} <= (SELECT COUNT(#{select_cols}) #{rest})"
      else
        "EXISTS(SELECT #{select_cols} #{rest})"
      end
    end

    def query_parts(parent, association)
      child_t = association.quoted_table_name
      parent_t = parent.quoted_table_name
      [
        "#{child_t}.#{association.primary_key_name}",
        "FROM #{child_t} WHERE #{parent_t}.#{parent.primary_key} = #{child_t}.#{association.primary_key_name}"
      ]
    end
  end
end

