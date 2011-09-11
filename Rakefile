require "bundler/gem_tasks"
require 'rake'
require 'rake/testtask'

task :default => :test

desc 'Run unit tests'
Rake::TestTask.new('test') do |t|
  #t.libs << 'lib'
  t.pattern = 'test/*_test.rb'
  t.verbose = true
end