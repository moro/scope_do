require 'scope_do/named_acl/builder'

module ScopeDo
  module NamedAcl
    def self.included(base)
      base.extend ClassMethods
      base.cattr_accessor :acl_query_builder
    end

    module ClassMethods
      def named_acl(target, options={})
        t_klass = target.to_s.classify.constantize
        self.acl_query_builder = Builder.new(self, target, options)

        define_accessible_scope(t_klass, acl_query_builder.query("#{t_klass.quoted_table_name}.#{t_klass.primary_key}"))

        class_eval(<<-EOS)
        def accessible_#{target}; #{t_klass.name}.accessed_by(self) ; end
        EOS

        if free = t_klass.scopes[:free]
          define_free_or_accessible_scope(t_klass, free.call(t_klass))
          class_eval(<<-EOS)
          def free_or_accessible_#{target}; #{t_klass.name}.free_or_accessed_by(self); end
          EOS
        end
      end

      private
      def define_accessible_scope(klass, query)
        klass.named_scope :accessed_by, proc{|*users|
          user_ids = users.map(&:id)
          {:conditions => ["EXISTS (#{query})", {:user_ids => user_ids}]}
        }
      end

      def define_free_or_accessible_scope(klass, free_scope)
        free = merge_conditions( free_scope.proxy_options[:conditions] )

        klass.named_scope :free_or_accessed_by, proc{|*users|
          accessible = merge_conditions( klass.accessed_by(*users).proxy_options[:conditions] )
          {:conditions => "(#{free}) OR (#{accessible})"}
        }
      end
    end

    def accessible?(record)
      @accessibilities ||= load_accessibilities

      fk = acl_query_builder.accessibility_target_id(false)
      @accessibilities.any?{|a| a[fk] == record.id }
    end

    private
    def load_accessibilities
      q = acl_query_builder
      q.accessibility_klass.find(:all, :joins => "JOIN #{q.join_on_group_id}",
                                       :conditions => ["#{q.where}", {q.label.to_sym=> self}])
    end
  end
end

