require 'find'

class DeadCode
  attr_reader :classes

  def initialize
    @classes = {}
  end

  def find_classes file_path
    File.open(file_path, 'r').each_with_index do |line, line_number|
      if line =~ /^class\s+(\w+)/
        match = $1
        next if match =~ /Controller$/
        @classes[match] = "#{file_path}:#{line_number}"
      end
    end
    @classes.keys
  end

  def find_class_files root_path
    files = []
    Find.find(root_path) do |path|
      files << path if path =~ /\.rb$/
    end
    files
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

  def find_usage_files root_path
    files = []
    Find.find(root_path) do |path|
      files << path if path =~ /\.(rb|rake|erb|yml|yaml)$/
    end
    files    
  end

    #NOT DONE
  def find_rails_files rails_root
    find_files "#{rails_root}/app/"
    find_files "#{rails_root}/lib/"
  end
end
