require File.join(File.dirname(__FILE__), '/../lib/dead_code')
require 'test/unit'

class DeadClassesTest < Test::Unit::TestCase

  include DeadCode

  def setup
    @spectre = Classes.new
  end

  def test_classes_are_found
    results = @spectre.find_all_definitions "test/data/classes.rb"
    assert results.include?("ImAClass")
    assert results.include?("JacobLikesPoop")
  end

  def test_find_unused_classes
    @spectre.find_all_definitions "test/data/classes.rb"
    @spectre.find_unused "test/data/classes.rb"
    assert @spectre.unused.include?("JacobLikesPoop")
    assert !@spectre.unused.include?("ImAClass")
  end
  
  def test_find_subclass_usages
    @spectre.find_all_definitions "test/data/classes.rb"
    @spectre.find_unused "test/data/classes.rb"
    assert !@spectre.unused.include?("IHaveBeenSubbed")
  end
  
  def test_find_class_name_usages
    @spectre.find_all_definitions "test/data/classes.rb"
    @spectre.find_unused "test/data/classes.rb"
    assert !@spectre.unused.include?("UsedByClassName")
  end
end
