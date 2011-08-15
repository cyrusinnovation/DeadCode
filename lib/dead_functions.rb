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
      if line =~ /def\s+(self\.)?(\w+\??)/
        match = $2
        next if file_path =~ /controller\.rb/
        next if commented_out_function line
        @functions[match] = "#{file_path}:#{line_number}"
      end
    end
    @functions.keys
  end

  def find_unused_functions file_path
    used_functions = []
    @functions.keys.each do |function|
      escaped_function = function.gsub '?', '\?'
      usages = File.open(file_path, 'r').grep(/(?:^|\W+)#{escaped_function}(?:\W+|$)/) do |line|
        line unless line.include?("def")
      end
      usages.compact!
      used_functions << function unless usages.empty?
    end

    used_functions.uniq.each do |functions|
      @functions.delete functions
    end

    remove_known_used_functions
  end

  private
  def remove_known_used_functions
    @functions.delete 'initialize'
    @functions.delete 'method_missing'
  end

  def commented_out_function line
    def_at = line.index "def "
    comment_at = line.index "#"
    return true if comment_at && comment_at < def_at
    false
  end

end
