require 'rubygems'
require 'rake'

desc 'Default: run specs'
task :default => :spec

require 'spec/rake/spectask'

spec_files = Rake::FileList["spec/*_spec.rb"]

desc "Run specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = spec_files
  t.spec_opts = %w(-c)
end
