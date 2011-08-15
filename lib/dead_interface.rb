require File.join(File.dirname(__FILE__), "/dead_file_finder")

class DeadInterface
  attr_reader :unused

  def initialize
    @unused = {}
  end

  def self.find_dead_code root_path, use_rails
    corpse = self.new
    if use_rails
      definition_files = DeadFileFinder.find_rails_class_files root_path
      usage_files = DeadFileFinder.find_rails_usage_files root_path
    else
      definition_files = DeadFileFinder.find_class_files root_path
      usage_files = DeadFileFinder.find_usage_files root_path
    end

    definition_files.each do |file|
      corpse.find_all_definitions file
    end

    usage_files.each do |file|
      corpse.find_unused file
    end

    corpse.unused.each do |definition, usage|
      puts "#{definition} unused at #{usage}"
    end
  end

  def find_all_definitions file_path
    File.open(file_path, 'r').each_with_index do |line, line_number|
      match = match_definition line
      unless match.nil?
        next if file_path =~ /controller\.rb/
        next if commented_out_definition line
        @unused[match] = "#{file_path}:#{line_number}"
      end
    end
    remove_unused
    @unused.keys
  end

  def find_unused file_path
    used = []
    @unused.keys.each do |definition|
      usages = find_usages file_path, definition
      used << definition unless usages.empty?
    end

    used.uniq.each do |definition|
      @unused.delete definition
    end
  end

  private
  def remove_unused
  end

  def commented_out_definition line
    def_at = line.index definition_keyword + " "
    comment_at = line.index "#"
    return true if comment_at && comment_at < def_at
    false
  end

end
