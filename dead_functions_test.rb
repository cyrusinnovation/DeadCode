require "test/unit"
require "dead_functions"

class DeadFunctionsTest < Test::Unit::TestCase

  def setup
    @wraith = DeadFunctions.new
  end
  
  def test_find_all_functions
    results = @wraith.find_all_functions "test_data/functions.rb"
    assert results.include?("here_is_a_func")
    assert results.include?("im_in_a_class")
  end
  
  def test_find_unused_functions
    @wraith.find_all_functions "test_data/functions.rb"
    @wraith.find_unused_functions "test_data/functions.rb"
    
    assert @wraith.functions.include?("here_is_a_func")
    assert !@wraith.functions.include?("im_in_a_class")
  end
end