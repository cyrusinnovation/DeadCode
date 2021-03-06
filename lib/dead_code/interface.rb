module DeadCode

  class Interface
    attr_reader :unused

    def initialize
      @unused = {}
    end

    def self.find_dead_code root_path, use_rails
      corpse = self.new
      if use_rails
        definition_files = FileFinder.find_rails_definition_files root_path
        usage_files = FileFinder.find_rails_usage_files root_path
      else
        definition_files = FileFinder.find_definition_files root_path
        usage_files = FileFinder.find_usage_files root_path
      end

      definition_files.each do |file|
        corpse.find_all_definitions file, use_rails
      end

      usage_files.each do |file|
        corpse.find_unused file, use_rails
      end

      corpse.unused.each do |definition, usage|
        puts "#{definition} unused at #{usage}"
      end
    end

    def find_all_definitions file_path, use_rails=false
      File.open(file_path, 'r').each_with_index do |line, line_number|
        match = match_definition line
        unless match.nil?
          next if use_rails && file_path =~ /controller\.rb/
          next if commented_out_definition line
          @unused[match] = "#{file_path}:#{line_number}"
        end
      end
      remove_unused
      @unused.keys
    end

    def find_unused file_path, use_rails=false
      used = []
      @unused.keys.each do |definition|
        used << definition if is_used? file_path, definition, use_rails
      end

      used.each do |definition|
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
end