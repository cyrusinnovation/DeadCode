require 'find'
require File.join(File.dirname(__FILE__), "/dead_file_finder")

class DeadClasses
  attr_reader :classes

  def self.find_dead_code root_path, use_rails
    corpse = DeadClasses.new
    if use_rails
      class_files = DeadFileFinder.find_rails_class_files root_path
      usage_files = DeadFileFinder.find_rails_usage_files root_path
    else
      class_files = DeadFileFinder.find_class_files root_path
      usage_files = DeadFileFinder.find_usage_files root_path
    end

    class_files.each do |file|
      corpse.find_all_classes file
    end

    usage_files.each do |file|
      corpse.find_unused_classes file
    end

    corpse.classes.each do |klass, usage|
      puts "#{klass} unused at #{usage}"
    end
  end

  def initialize
    @classes = {}
  end

  def find_all_classes file_path
    File.open(file_path, 'r').each_with_index do |line, line_number|
      if line =~ /^class\s+(\w+)/
        match = $1
        next if match =~ /Controller$/
        @classes[match] = "#{file_path}:#{line_number}"
      end
    end
    @classes.keys
  end

  def find_unused_classes file_path
    used_classes = []
    @classes.keys.each do |klass|
      usages = File.open(file_path, 'r').grep(/\b#{klass}\./)
      usages += File.open(file_path, 'r').grep(/<\b#{klass}/)
      used_classes << klass unless usages.empty?
    end

    used_classes.uniq.each do |klass|
      @classes.delete klass
    end
  end

end
