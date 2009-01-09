# ---- requirements
$KCODE = 'u' #activate regex unicode
require 'rubygems'
require 'spec'
$LOAD_PATH << File.expand_path("..", File.dirname(__FILE__))
$LOAD_PATH << File.expand_path("../lib", File.dirname(__FILE__))

# ---- bugfix
#`exit?': undefined method `run?' for Test::Unit:Module (NoMethodError)
#can be solved with require test/unit but this will result in extra test-output
unless defined? Test::Unit
  module Test
    module Unit
      def self.run?
        true
      end
    end
  end
end

# ---- load active record
#gem 'activerecord', '2.0.2'
if ENV["AR"]
  gem 'activerecord', ENV["AR"]
  $stderr.puts("Using ActiveRecord #{ENV["AR"]}")
end
require 'active_record'
require "rails/init"

load File.expand_path("setup_test_model.rb", File.dirname(__FILE__))

# ---- fixtures
Spec::Example::ExampleGroupMethods.module_eval do
  def fixtures(*tables)
    dir = File.expand_path("fixtures", File.dirname(__FILE__))
    tables.each{|table| Fixtures.create_fixtures(dir, table.to_s) }
  end
end

