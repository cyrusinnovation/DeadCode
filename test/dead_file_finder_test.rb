require "test/unit"
require File.join(File.dirname(__FILE__), "/../lib/dead_code")

class DeadFileFinderTest < Test::Unit::TestCase

  include DeadCode

  def test_rails_class_files_are_found
    results = FileFinder.find_rails_definition_files "test/data", true
    assert results.include?("test/data/app/models/classes.rb")
    assert results.include?("test/data/lib/classes.rb")
    assert !results.include?("test/data/config/usages.rb")
  end

  def test_rails_usage_files_are_found
    results = FileFinder.find_rails_usage_files "test/data", true
    assert results.include?("test/data/app/models/classes.rb")
    assert results.include?("test/data/app/views/some_controller/remember_me.html.erb")
    assert results.include?("test/data/config/usages.rb")
  end

  def test_correct_class_files_are_found
    results = FileFinder.find_definition_files "test/data", true
    assert results.include?("test/data/classes.rb")
    assert !results.include?("test/data/ignore_me.js")
  end

  def test_correct_usage_files_are_found
    results = FileFinder.find_usage_files "test/data", true
    assert results.include?("test/data/classes.rb")
    assert results.include?("test/data/remember_me.html.erb")
    assert !results.include?("test/data/ignore_me.js")
  end
end