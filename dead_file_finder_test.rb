require "test/unit"
require "dead_file_finder"

class DeadFileFinderTest < Test::Unit::TestCase

  def test_rails_class_files_are_found
    results = DeadFileFinder.find_rails_class_files "test_data"
    assert results.include?("test_data/app/models/classes.rb")
    assert results.include?("test_data/lib/classes.rb")
    assert !results.include?("test_data/config/usages.rb")
  end

  def test_rails_usage_files_are_found
    results = DeadFileFinder.find_rails_usage_files "test_data"
    assert results.include?("test_data/app/models/classes.rb")
    assert results.include?("test_data/app/views/some_controller/remember_me.html.erb")
    assert results.include?("test_data/config/usages.rb")
  end

  def test_correct_class_files_are_found
    results = DeadFileFinder.find_class_files "test_data"
    assert results.include?("test_data/classes.rb")
    assert !results.include?("test_data/ignore_me.js")
  end

  def test_correct_usage_files_are_found
    results = DeadFileFinder.find_usage_files "test_data"
    assert results.include?("test_data/classes.rb")
    assert results.include?("test_data/remember_me.html.erb")
    assert !results.include?("test_data/ignore_me.js")
  end
end