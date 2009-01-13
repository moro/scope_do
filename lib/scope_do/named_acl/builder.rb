module ScopeDo
  module NamedAcl
    class Builder
      attr_reader :label

      def initialize(user_klass, target, options={})
        options = {:via => :groups, :label => "user_ids"}.merge(options)
        @label = options[:label]

        @user = user_klass
        @group = @user.reflections[options[:via]]
        @membership = @user.reflections[options[:via]].through_reflection

        @target = @group.klass.reflections[target]
        @accessibility = @target.through_reflection
      end

      def accessibility_klass
        @accessibility.klass
      end

      def query
        "SELECT #{accessibility_target_id} FROM #{from} JOIN #{join_on_group_id} WHERE #{where}"
      end

      def accessibility_target_id
        "#{@accessibility.quoted_table_name}.#{@target.association_foreign_key}"
      end

      def where
        "#{@membership.quoted_table_name}.#{@membership.primary_key_name} IN (:#{@label})"
      end

      def from
        @accessibility.quoted_table_name
      end

      def join_on_group_id
        "#{@membership.quoted_table_name} ON " +
        "#{@membership.quoted_table_name}.#{@group.association_foreign_key} = " +
        "#{@accessibility.quoted_table_name}.#{@accessibility.primary_key_name}"
      end
    end
  end
end
