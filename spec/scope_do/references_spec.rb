#!/usr/bin/env ruby
# vim:set fileencoding=utf-8 filetype=ruby
# $KCODE = 'u'

require File.expand_path("../spec_helper", File.dirname(__FILE__))
require 'scope_do/reference_scope'

describe ScopeDo::ReferenceScope do
  before(:all) do
    ::Publication.class_eval do
      named_scope :since, lambda{|t| {:conditions => ["#{quoted_table_name}.published_at < ?", t]} }
    end
    ::Entry.class_eval do
      scope_do :reference_scope
      reference_scope :publication, :since, :as => :published
    end

    [Entry, Publication].each(&:delete_all)

    draft, *published = (0...5).map{|i| Factory(:entry) }
    t = 3.hours.ago
    published.each{|e| e.create_publication(:published_at => t) }
  end

  it{ Publication.since(Time.now).count.should == 4 }
  it{ Entry.published(Time.now).count.should == 4 }
end

