require 'find'
require "dead_file_finder"

class DeadClasses
  attr_reader :classes

  def self.find_dead_code root_path
    corpse = DeadClasses.new
    files = DeadFileFinder.find_class_files root_path
    files.each do |file|
      corpse.find_all_classes file
    end

    files = DeadFileFinder.find_usage_files root_path
    files.each do |file|
      corpse.find_unused_classes file
    end

    corpse.classes.each do |klass, usage|
      puts "#{klass} unused at #{usage}"
    end
  end

  def self.find_dead_rails_code root_path
    corpse = DeadClasses.new
    files = DeadFileFinder.find_rails_class_files root_path
    files.each do |file|
      corpse.find_all_classes file
    end

    files = DeadFileFinder.find_rails_usage_files root_path
    files.each do |file|
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
      used_classes << klass unless usages.empty?
    end

    used_classes.uniq.each do |klass|
      @classes.delete klass
    end
  end

end
