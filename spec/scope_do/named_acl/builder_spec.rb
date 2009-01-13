#!/usr/bin/env ruby
# vim:set fileencoding=utf-8 filetype=ruby
# $KCODE = 'u'

require File.expand_path("../../spec_helper", File.dirname(__FILE__))
require 'scope_do/named_acl/builder'

describe ScopeDo::NamedAcl::Builder do
  before do
    @builder = ScopeDo::NamedAcl::Builder.new(User, :blogs, :via => :groups)
  end

  it do
    @builder.should_not be_nil
  end

  it "#from" do
    @builder.from.should == Accessibility.quoted_table_name
  end

  it "#join_on_group_id" do
    @builder.join_on_group_id.should == "#{Membership.quoted_table_name} ON #{Membership.quoted_table_name}.group_id = #{Accessibility.quoted_table_name}.group_id"
  end
end

