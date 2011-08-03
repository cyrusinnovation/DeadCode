require 'dead_code'
require 'test/unit'

class DeadCodeTest < Test::Unit::TestCase
  def test_classes_are_found
    results = DeadCode.new.find_classes "test_data/classes.rb"
    assert results.include?("ImAClass")
    assert results.include?("JacobLikesPoop")
  end

  def test_correct_files_are_found
    results = DeadCode.new.find_files "test_data"
    assert results.include?("test_data/classes.rb")
    assert !results.include?("ignore_me.js")
  end

end
