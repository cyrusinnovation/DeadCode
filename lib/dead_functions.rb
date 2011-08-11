require 'find'
require File.join(File.dirname(__FILE__), "/dead_file_finder")

class DeadFunctions
  attr_reader :functions

  def self.find_dead_code root_path, use_rails
    corpse = DeadFunctions.new
    if use_rails
      function_files = DeadFileFinder.find_rails_class_files root_path
      usage_files = DeadFileFinder.find_rails_usage_files root_path
    else
      function_files = DeadFileFinder.find_class_files root_path
      usage_files = DeadFileFinder.find_usage_files root_path
    end

    function_files.each do |file|
      corpse.find_all_functions file
    end

    usage_files.each do |file|
      corpse.find_unused_functions file
    end

    corpse.functions.each do |klass, usage|
      puts "#{klass} unused at #{usage}"
    end
  end

  def initialize
    @functions = {}
  end

  def find_all_functions file_path
    File.open(file_path, 'r').each_with_index do |line, line_number|
      if line =~ /def\s+(self\.)?(\w+)/
        @functions[$2] = "#{file_path}:#{line_number}"
      end
    end
    @functions.keys
  end

  def find_unused_functions file_path
    used_functions = []
    @functions.keys.each do |function|
      usages = File.open(file_path, 'r').grep(/[\.\s]#{function}[\s(]/) do |line|
        line unless line.include?("def")
      end
      usages.compact!
      used_functions << function unless usages.empty?
    end

    used_functions.uniq.each do |functions|
      @functions.delete functions
    end
  end

end