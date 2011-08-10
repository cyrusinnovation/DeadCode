require 'dead_code'
require 'test/unit'

class DeadCodeTest < Test::Unit::TestCase

  def setup
    @spectre = DeadCode.new
  end
  
  def test_rails_class_files_are_found
    results = @spectre.find_rails_class_files "test_data"
    assert results.include?("test_data/app/models/classes.rb")
    assert results.include?("test_data/lib/classes.rb")
    assert !results.include?("test_data/config/usages.rb")
  end
  
  def test_rails_usage_files_are_found
    results = @spectre.find_rails_usage_files "test_data"
    assert results.include?("test_data/app/models/classes.rb")
    assert results.include?("test_data/app/views/some_controller/remember_me.html.erb")
    assert results.include?("test_data/config/usages.rb")
  end

  def test_classes_are_found
    results = @spectre.find_all_classes "test_data/classes.rb"
    assert results.include?("ImAClass")
    assert results.include?("JacobLikesPoop")
  end

  def test_correct_class_files_are_found
    results = @spectre.find_class_files "test_data"
    assert results.include?("test_data/classes.rb")
    assert !results.include?("test_data/ignore_me.js")
  end

  def test_usages_are_found
    @spectre.find_all_classes "test_data/classes.rb"
    @spectre.find_unused_classes "test_data/classes.rb"
    assert @spectre.classes.include?("JacobLikesPoop")
    assert !@spectre.classes.include?("ImAClass")
  end

  def test_correct_usage_files_are_found
    results = @spectre.find_usage_files "test_data"
    assert results.include?("test_data/classes.rb")
    assert results.include?("test_data/remember_me.html.erb")
    assert !results.include?("test_data/ignore_me.js")
  end

end
