require 'dead_code'
require 'test/unit'

class DeadCodeTest < Test::Unit::TestCase

  def setup
    @spectre = DeadCode.new
  end

  def test_classes_are_found
    results = @spectre.find_classes "test_data/classes.rb"
    assert results.include?("ImAClass")
    assert results.include?("JacobLikesPoop")
  end

  def test_correct_files_are_found
    results = @spectre.find_files "test_data"
    assert results.include?("test_data/classes.rb")
    assert !results.include?("ignore_me.js")
  end

  def test_usages_are_found
    @spectre.find_classes "test_data/classes.rb"
    @spectre.find_unused_classes "test_data/classes.rb"
    assert @spectre.classes.include?("JacobLikesPoop")
    assert !@spectre.classes.include?("ImAClass")
  end
end
