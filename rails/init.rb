#require File.expand_path("..", File.dirname(__FILE__))
require 'scope_do'

ActiveRecord::Base.extend(ScopeDo::Adapter)

