require File.join(File.dirname(__FILE__), "/dead_interface")

class DeadClasses < DeadInterface
  private
  def match_definition line
    line =~ /^class\s+(\w+)/ ? $1 : nil
  end

  def definition_keyword
    "class"
  end

  def find_usages file_path, klass
    usages = File.open(file_path, 'r').grep(/\b#{klass}\./)
    usages += File.open(file_path, 'r').grep(/<\s*#{klass}/)
    usages += File.open(file_path, 'r').grep(/#{klass}::/)
    usages
  end
end
