require "test/unit"
require File.join(File.dirname(__FILE__), "/../lib/dead_functions")

class DeadFunctionsTest < Test::Unit::TestCase

  def setup
    @wraith = DeadFunctions.new
  end
  
  def test_find_all_functions
    results = @wraith.find_all_functions "test_data/functions.rb"
    assert results.include?("here_is_a_func")
    assert results.include?("im_in_a_class")
  end

  def test_does_not_find_commented_functions
    results = @wraith.find_all_functions "test_data/functions.rb"
    assert !results.include?("ignore_me_i_am_a_comment")
  end
  
  def test_find_unused_functions
    @wraith.find_all_functions "test_data/functions.rb"
    @wraith.find_unused_functions "test_data/functions.rb"
    
    assert @wraith.functions.include?("here_is_a_func")
    assert !@wraith.functions.include?("im_in_a_class")
  end

  def test_finds_chained_methods
    assert_function_found_and_used "test_chaining"
  end

  def test_finds_question_mark_methods
    assert_function_found_and_used "test_question_mark?"
  end

  def test_finds_functions_at_beginning_or_ending_of_line
    assert_function_found_and_used "test_no_space_around_call"
  end

  def test_finds_functions_with_trailing_comma
    assert_function_found_and_used "test_trailing_comma"
  end

  def test_finds_functions_calls_ending_with_square_bracket
    assert_function_found_and_used "test_trailing_square_bracket"
  end

  def test_known_used_methods
    assert_function_found_and_used "initialize"
    assert_function_found_and_used "method_missing"
  end

  def test_usage_with_def_in_the_line
    assert_function_found_and_used "test_arg_usage_contains_def"
  end

  private

  def assert_function_found_and_used function
    @wraith.find_all_functions "test_data/functions.rb"
    assert @wraith.functions.include?(function)

    @wraith.find_unused_functions "test_data/functions.rb"
    assert !@wraith.functions.include?(function)

  end

end
