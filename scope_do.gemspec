# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{scope_do}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["MOROHASHI Kyosuke"]
  s.date = %q{2009-02-18}
  s.description = %q{named_scope utilities.}
  s.email = %q{moronatural@gmail.com}
  s.extra_rdoc_files = ["README.rdoc", "ChangeLog"]
  s.files = ["README.rdoc", "ChangeLog", "Rakefile", "lib/scope_do", "lib/scope_do/chained_scope.rb", "lib/scope_do/has_children.rb", "lib/scope_do/named_acl", "lib/scope_do/named_acl/builder.rb", "lib/scope_do/named_acl.rb", "lib/scope_do.rb", "spec/record_extention_test_util.rb", "spec/scope_do/chained_scope_spec.rb", "spec/scope_do/has_children_spec.rb", "spec/scope_do/named_acl/builder_spec.rb", "spec/scope_do/named_acl_spec.rb", "spec/setup_test_model.rb", "spec/spec_helper.rb", "rails/init.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/moro/scope_do/tree/master}
  s.rdoc_options = ["--title", "scope_do documentation", "--charset", "utf-8", "--opname", "index.html", "--line-numbers", "--main", "README.rdoc", "--inline-source", "--exclude", "^(examples|extras)/"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{named_scope utilities.}
  s.test_files = ["spec/scope_do/chained_scope_spec.rb", "spec/scope_do/has_children_spec.rb", "spec/scope_do/named_acl/builder_spec.rb", "spec/scope_do/named_acl_spec.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
