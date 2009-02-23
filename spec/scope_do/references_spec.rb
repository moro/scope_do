#!/usr/bin/env ruby
# vim:set fileencoding=utf-8 filetype=ruby
# $KCODE = 'u'

require File.expand_path("../spec_helper", File.dirname(__FILE__))
require 'scope_do/reference_scope'

describe ScopeDo::ReferenceScope do
  before(:all) do
    ::Entry.class_eval do
      scope_do :reference_scope
      reference_scope :publication, :since, :as => :published_since
    end

    [Entry, Publication].each(&:delete_all)

    draft, *published = 5.times{ Factory(:entry) }
    t = 3.hours.ago
    published.each{|e| e.create_publication(:published_at => t) }
  end

  it{ :ok }
end

