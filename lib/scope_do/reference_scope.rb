module ScopeDo
  module ReferenceScope
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def reference_scope(*args)
      end
    end
  end
end

