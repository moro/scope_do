module ScopeDo
  module NamedAcl
    class Builder
      def initialize(user_klass, target_klass, options={})
        options = {:via => :groups, :label => ":user_ids"}.merge(options)
        @label = options[:label]

        @user = user_klass
        @membership = @user.reflections[options[:via]].through_reflection.klass
        @group = @user.reflections[options[:via]].klass
        @target = target_klass
        @accessibility = detect_reflection(@group, @target).through_reflection.klass
      end

      def query
        "SELECT #{accessibility_target_id} FROM #{from} JOIN #{join_on_group_id} WHERE #{where}"
      end

      def accessibilities_table
        @accessibility.quoted_table_name
      end

      def memberships_table
        @membership.quoted_table_name
      end

      def accessibility_target_id
        "#{accessibilities_table}.#{detect_reflection(@accessibility, @target).primary_key_name}"
      end

      def where
        "#{memberships_table}.#{detect_reflection(@membership, @user).primary_key_name} IN (#{@label})"
      end

      def from
        "#{@accessibility.quoted_table_name}"
      end

      def join_on_group_id
        m2g = detect_reflection(@membership, @group).primary_key_name
        a2g = detect_reflection(@accessibility, @group).primary_key_name
        "#{memberships_table} ON #{memberships_table}.#{m2g} = #{accessibilities_table}.#{a2g}"
      end

      def membership_user_id
        ref = detect_reflection(@membership, @user)
        "#{memberships_table}.#{ref.association_foreign_key}"
      end

      private
      def detect_reflection(from_klass, to_klass)
        from_klass.reflections.values.detect{|ref| ref.klass == to_klass }
      end
    end
  end
end
