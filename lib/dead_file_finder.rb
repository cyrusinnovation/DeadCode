require 'find'

class DeadFileFinder
  def self.find_class_files root_path, include_tests = false
    find_files_by_regex root_path, /\.rb$/, include_tests
  end

  def self.find_usage_files root_path, include_tests = false
    find_files_by_regex root_path, /\.(rb|rake|erb|yml|yaml)$/, include_tests
  end

  def self.find_files_by_regex root_path, regex, include_tests
    files = []
    Find.find(root_path) do |path|
      if path =~ regex && (include_tests || !path.include?("test"))
        files << path
      end
    end
    files
  end

  def self.find_rails_class_files rails_root, include_tests = false
    files = find_class_files "#{rails_root}/app/", include_tests
    files += find_class_files "#{rails_root}/lib/", include_tests
  end

  def self.find_rails_usage_files rails_root, include_tests = false
    files = []
    ["app", "lib", "config", "db", "script"].each do |folder|
      files += find_usage_files "#{rails_root}/#{folder}/", include_tests
    end
    files
  end

end
