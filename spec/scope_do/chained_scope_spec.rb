#!/usr/bin/env ruby
# vim:set fileencoding=utf-8 filetype=ruby
# $KCODE = 'u'

require File.expand_path("../spec_helper", File.dirname(__FILE__))
require 'scope_do/chained_scope'

describe ScopeDo::ChainedScope do
  before(:all) do
    ::User.class_eval do
      scope_do :chained_scope
      named_scope :name_like, proc{|part|
        {:conditions => ["#{quoted_table_name}.name LIKE ?", "%#{part}%"]}
      }

      named_scope :name_starts, proc{|part|
        {:conditions => ["#{quoted_table_name}.name LIKE ?", "#{part}%"]}
      }

      chainable_scope :name_like
      chainable_scope :name_starts, :halt => true
    end

    User.delete_all
    u = Factory(:user)
    Factory(:user, :name => "bob")
  end

  it "name_like('ali') should == [User.find_by_name('alice')]" do
    User.name_like('ali').should == [User.find_by_name('alice')]
  end

  it "blank paramters (nil, [], '') on name_like should == User.all" do
    [nil, [], ''].all?{|param| User.name_like(param) == User.all }.should be_true
  end

  it "blank paramters (nil, [], '') on name_starts should == []" do
    [nil, [], ''].all?{|param| User.name_starts(param) == [] }.should be_true
  end
end

