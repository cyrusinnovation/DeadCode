class DeadFunctions
  attr_reader :functions

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
    @functions.keys.each do |functions|
      usages = File.open(file_path, 'r').grep(/[\s\.]#{functions}[ ($]/)
      used_functions << functions unless usages.empty?
    end

    used_functions.uniq.each do |functions|
      @functions.delete functions
    end
  end

end