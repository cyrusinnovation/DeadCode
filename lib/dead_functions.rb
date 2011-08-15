require File.join(File.dirname(__FILE__), "/dead_interface")

class DeadFunctions < DeadInterface
  private
  def match_definition line
    line =~ method_definition_regex ? $2 : nil
  end

  def find_usages file_path, function
    escaped_function = function.gsub '?', '\?'
    usages = File.open(file_path, 'r').grep(/(?:^|\W+)#{escaped_function}(?:\W+|$)/) do |line|
      line unless line =~ method_definition_regex
    end
    usages.compact!
  end

  def definition_keyword
    "def"
  end

  def remove_unused
    @unused.delete 'initialize'
    @unused.delete 'method_missing'
  end

  def method_definition_regex
    /def\s+(self\.)?(\w+\??)/
  end

end
