require File.join(File.dirname(__FILE__), '/../lib/dead_classes')
require 'test/unit'

class DeadClassesTest < Test::Unit::TestCase

  def setup
    @spectre = DeadClasses.new
  end

  def test_classes_are_found
    results = @spectre.find_all_classes "test_data/classes.rb"
    assert results.include?("ImAClass")
    assert results.include?("JacobLikesPoop")
  end

  def test_find_unused_classes
    @spectre.find_all_classes "test_data/classes.rb"
    @spectre.find_unused_classes "test_data/classes.rb"
    assert @spectre.unused_classes.include?("JacobLikesPoop")
    assert !@spectre.unused_classes.include?("ImAClass")
  end
  
  def test_find_subclass_usages
    @spectre.find_all_classes "test_data/classes.rb"
    @spectre.find_unused_classes "test_data/classes.rb"
    assert !@spectre.unused_classes.include?("IHaveBeenSubbed")
  end
end
