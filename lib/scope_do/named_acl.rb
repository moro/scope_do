require 'scope_do/named_acl/builder'

module ScopeDo
  module NamedAcl
    def self.included(base)
      base.extend ClassMethods
      base.cattr_accessor :acl_query_builder
    end

    #named_scope :has_pages, {:conditions => "EXISTS(SELECT lx.page_id FROM label_indexings AS lx WHERE #{quoted_table_name}.id = lx.label_index_id)"}

    module ClassMethods
      def named_acl(target, options={})
        t_klass = target.to_s.classify.constantize
        self.acl_query_builder = Builder.new(self, t_klass, options)

        define_accessible_scope(t_klass, acl_query_builder.query)

        class_eval(<<-EOS)
        def accessible_#{target}; #{t_klass.name}.accessed_by(self) ; end
        EOS
      end

      private
      def define_accessible_scope(klass, query)
        klass.named_scope :accessed_by, proc{|*users|
          user_ids = users.map(&:id)
          {:conditions => ["#{klass.quoted_table_name}.id IN (#{query})", {:user_ids => user_ids}]}
        }
      end
    end

    def accessible?(record)
      @accessibilities ||= load_accessibilities
      @accessibilities.any?{|a| a.blog_id == record.id }
    end

    private
    def load_accessibilities
      Accessibility.find(:all, :joins => "JOIN #{acl_query_builder.join_on_group_id}",
                               :conditions => ["#{Membership.quoted_table_name}.user_id = ?", self])
    end
  end
end

