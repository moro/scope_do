module ScopeDo
  module ReferenceScope
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def reference_scope(association, scope, options = {})
        scope_name = options[:as] || "#{association}_#{scope}".to_sym

        ref = self.reflections[association]
        impl = lambda{|arg|
          base = ref.active_record
          scope = ref.klass.send(scope, arg)
          jd = ActiveRecord::Associations::ClassMethods::InnerJoinDependency.new(base, association, scope.proxy_options[:joins])
          scope.proxy_options.dup.update(:joins => jd.join_associations.map{|j| j.association_join }.join(" "))
        }
        named_scope scope_name, impl
      end
    end
  end
end

