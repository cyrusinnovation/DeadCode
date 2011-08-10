require 'find'

class DeadClasses
  attr_reader :classes

  def self.find_dead_code root_path
    corpse = DeadClasses.new
    files = corpse.find_class_files root_path
    files.each do |file|
      corpse.find_all_classes file
    end

    files = corpse.find_usage_files root_path
    files.each do |file|
      corpse.find_unused_classes file
    end

    corpse.classes.each do |klass, usage|
      puts "#{klass} unused at #{usage}"
    end
  end

  def self.find_dead_rails_code root_path
    corpse = DeadClasses.new
    files = corpse.find_rails_class_files root_path
    files.each do |file|
      corpse.find_all_classes file
    end

    files = corpse.find_rails_usage_files root_path
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

  def find_class_files root_path
    files = []
    Find.find(root_path) do |path|
      files << path if path =~ /\.rb$/
    end
    files
  end

  def find_usage_files root_path
    files = []
    Find.find(root_path) do |path|
      files << path if path =~ /\.(rb|rake|erb|yml|yaml)$/
    end
    files
  end

  def find_rails_class_files rails_root
    files = find_class_files "#{rails_root}/app/"
    files += find_class_files "#{rails_root}/lib/"
  end

  def find_rails_usage_files rails_root
    files = []
    ["app", "lib", "config", "db", "script"].each do |folder|
      files += find_usage_files "#{rails_root}/#{folder}/"
    end
    files
  end
end
