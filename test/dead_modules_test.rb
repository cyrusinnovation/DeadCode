require "test/unit"
require File.join(File.dirname(__FILE__), '/../lib/dead_modules')

class DeadModulesTest < Test::Unit::TestCase
  
  def setup
    @spectre = DeadModules.new
  end

  def test_modules_are_found
    results = @spectre.find_all_definitions "test_data/modules.rb"
    assert results.include?("UnusedModule")
    assert results.include?("IncludedModule")
  end

  def test_find_unused_modules
    @spectre.find_all_definitions "test_data/modules.rb"
    @spectre.find_unused "test_data/modules.rb"
    assert @spectre.unused.include?("UnusedModule")
    assert !@spectre.unused.include?("IncludedModule")
  end
end
