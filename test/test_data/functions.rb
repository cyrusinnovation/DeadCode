def here_is_a_func
end

def test_no_space_around_call
end

test_no_space_around_call

class WorthlessClass
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

end


WorthlessClass.test_chaining.length
WorthlessClass.test_question_mark?

[WorthlessClass.test_trailing_comma, 1]
