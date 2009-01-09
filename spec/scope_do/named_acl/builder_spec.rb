#!/usr/bin/env ruby
# vim:set fileencoding=utf-8 filetype=ruby
# $KCODE = 'u'

require File.expand_path("../spec_helper", File.dirname(__FILE__))
require 'named_acl/builder'

describe NamedAcl::Builder do
  before do
    @builder = NamedAcl::Builder.new(User, Blog, :via => :groups)
  end

  it do
    @builder.should_not be_nil
  end

  it "#membership_user_id" do
    @builder.membership_user_id.should == "#{Membership.quoted_table_name}.user_id"
  end

  it "#from" do
    @builder.from.should == "#{Accessibility.quoted_table_name} AS a"
  end

  it "#join_on_group_id" do
    @builder.join_on_group_id.should == "#{Membership.quoted_table_name} AS m ON m.group_id = a.group_id"
  end
end

