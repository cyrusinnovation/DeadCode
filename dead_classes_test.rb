require 'dead_classes'
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

  def test_usages_are_found
    @spectre.find_all_classes "test_data/classes.rb"
    @spectre.find_unused_classes "test_data/classes.rb"
    assert @spectre.classes.include?("JacobLikesPoop")
    assert !@spectre.classes.include?("ImAClass")
  end
end
