#!/usr/bin/env ruby
# vim:set fileencoding=utf-8 filetype=ruby
# $KCODE = 'u'

require File.expand_path("../spec_helper", File.dirname(__FILE__))
require 'scope_do/named_acl'

describe ScopeDo::NamedAcl do
  before(:all) do
    ::Blog.class_eval do
      named_scope :free, :conditions => ["public = ?", true]
    end
    ::User.class_eval do
      scope_do :named_acl
      named_acl :blogs
    end

    [Blog, User].each(&:delete_all)
    u = Factory(:user)
    b = Factory(:blog)
    b.accessibilities.map(&:group).first.users << u
  end

  before do
    @alice = User.find_by_name("alice")
    @bob   = Factory(:user, :name => "bob")
    @blog  = Blog.find(:first)
  end

  it do
    Blog.should be_respond_to(:accessed_by)
  end

  it "alice.accessible_blogs should include @blog" do
    @alice.accessible_blogs.should include(@blog)
  end

  it "alice should be accessible @blog" do
    @alice.should be_accessible(@blog)
  end

  it "bob.accessible_blogs should not include @blog" do
    @bob.accessible_blogs.should_not include(@blog)
  end

  it "bob.free_or_accessible_blogs should not include @blog" do
    @bob.free_or_accessible_blogs.should include(@blog)
  end

  it "bob should not be accessible @blog" do
    @bob.should_not be_accessible(@blog)
  end
end

