require "test/unit"
require File.join(File.dirname(__FILE__), "/../lib/dead_code")

class DeadFunctionsTest < Test::Unit::TestCase

  include DeadCode

  def setup
    @wraith = Functions.new
  end
  
  def test_find_all_functions
    results = @wraith.find_all_definitions "test/data/functions.rb"
    assert results.include?("here_is_a_func")
    assert results.include?("im_in_a_class")
  end

  def test_does_not_find_commented_functions
    results = @wraith.find_all_definitions "test/data/functions.rb"
    assert !results.include?("ignore_me_i_am_a_comment")
  end
  
  def test_find_unused_functions
    @wraith.find_all_definitions "test/data/functions.rb"
    @wraith.find_unused "test/data/functions.rb"
    
    assert @wraith.unused.include?("here_is_a_func")
    assert !@wraith.unused.include?("im_in_a_class")
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
    @wraith.find_all_definitions "test/data/functions.rb"
    assert !@wraith.unused.include?("initialize")
    assert !@wraith.unused.include?("method_missing")
  end

  def test_usage_with_def_in_the_line
    assert_function_found_and_used "test_arg_usage_contains_def"
  end

  def test_a_commented_out_method_call_does_not_count
    @wraith.find_all_definitions "test/data/commented_out_usage.rb"

    assert @wraith.unused.include?("tryme")
    assert @wraith.unused.include?("this_piggy_went_to_the_bank")
  end

  private

  def assert_function_found_and_used function
    @wraith.find_all_definitions "test/data/functions.rb"
    assert @wraith.unused.include?(function)

    @wraith.find_unused "test/data/functions.rb"
    assert !@wraith.unused.include?(function)
  end

end
