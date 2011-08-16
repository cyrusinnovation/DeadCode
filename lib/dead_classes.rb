require File.join(File.dirname(__FILE__), "/dead_interface")

class DeadClasses < DeadInterface
  private
  def match_definition line
    line =~ /^class\s+(\w+)/ ? $1 : nil
  end

  def definition_keyword
    "class"
  end

  def is_used? file_path, klass
    !(File.open(file_path, 'r').grep(/\W#{klass}\./).empty? &&
    File.open(file_path, 'r').grep(/<\s*#{klass}/).empty? &&
    File.open(file_path, 'r').grep(/#{klass}::/).empty?)
  end
end
