#!/usr/bin/env ruby
# vim:set fileencoding=utf-8 filetype=ruby
# $KCODE = 'u'

require File.expand_path("../spec_helper", File.dirname(__FILE__))
require 'scope_do/has_children'

describe ScopeDo::HasChildren do
  before(:all) do
    ::Blog.class_eval do
      scope_do :has_children
      has_children :entries
    end
  end

  before do
    [Blog, Entry, Group, User].each(&:delete_all)
    @blog = Factory(:blog)
    @blog.entries << (@entry = Factory(:entry))

    @empty = Factory(:blog)
  end

  it do
    Blog.first.should have(1).entries
  end

  it do
    Blog.all.should == [@blog, @empty]
  end

  it ".has_entries" do
    Blog.has_entries.should == [@blog]
  end

  describe "specify children numbers" do
    before do
      @three_children = Factory(:blog)
      @three_children.entries = (0..2).map{ Factory(:entry) }
    end

    it ".has_entries(3)" do
      Blog.has_entries(3).should == [@three_children]
    end

    it ".has_entries(4) should be_empty" do
      Blog.has_entries(4).should be_empty
    end
  end

  describe "Group / has_many :through children" do
    before(:all) do
      Group.class_eval do
        scope_do :has_children
        has_children :users
      end
    end
    before do
      @group = Group.first
      @group.users = [Factory(:user)]
      @another_group = Factory(:group)
    end

    it ".has_users" do
      Group.has_users.should == [@group]
    end

    describe "specify n" do
      before do
        @group.users << Factory(:user, :name =>"bob")
      end

      it ".has_users(2).should == [@group]" do
        Group.has_users(2).should == [@group]
      end

      it ".has_users(5).should be_empty" do
        Group.has_users(5).should be_empty
      end
    end
  end
end

