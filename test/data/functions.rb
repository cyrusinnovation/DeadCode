def here_is_a_func
end

def test_no_space_around_call
end

test_no_space_around_call

class WorthlessClass
  def initialize
  end

  def method_missing
  end

  def self.im_in_a_class
  end

  self.im_in_a_class

  def self.test_chaining
    "string"
  end

  def self.test_question_mark?
  end

  def self.test_trailing_comma
  end

  def self.test_trailing_square_bracket
  end

  def self.test_arg_usage_contains_def arg
  end

  [test_trailing_square_bracket]

end

WorthlessClass.test_chaining.length
WorthlessClass.test_question_mark?

[WorthlessClass.test_trailing_comma, 1]

# def ignore_me_i_am_a_comment

WorthlessClass.test_arg_usage_contains_def "def"
