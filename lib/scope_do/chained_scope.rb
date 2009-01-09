require 'active_record'

module ChainedScope
  module ClassMethods

    # Make specified named_scope(s) chainable
    #
    # options
    #
    # +halt+:: add always false condition (WHERE 1 = 2)
    def chainable_scope(*scope_names)
      opts = scope_names.extract_options!
      opts.symbolize_keys!

      scope_names.each do |scope_name|
        if defined_scope = scopes[scope_name]
          scopes[scope_name] = proc{|parent_scope, *args|
            args.flatten.any?{|x| !x.blank? } ?
              defined_scope.call(parent_scope, *args) : parent_scope.scoped(chain_condition(opts))
          }
        end
      end
    end

    private
    def chain_condition(options) # nodoc
      options[:halt] ? {:conditions => "1 = 2"} : {}
    end
  end
end
