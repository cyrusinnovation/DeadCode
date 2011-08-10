class DeadFileFinder
  def self.find_class_files root_path
    files = []
    Find.find(root_path) do |path|
      files << path if path =~ /\.rb$/
    end
    files
  end

  def self.find_usage_files root_path
    files = []
    Find.find(root_path) do |path|
      files << path if path =~ /\.(rb|rake|erb|yml|yaml)$/
    end
    files
  end
  
  def self.find_rails_class_files rails_root
    files = find_class_files "#{rails_root}/app/"
    files += find_class_files "#{rails_root}/lib/"
  end

  def self.find_rails_usage_files rails_root
    files = []
    ["app", "lib", "config", "db", "script"].each do |folder|
      files += find_usage_files "#{rails_root}/#{folder}/"
    end
    files
  end
  
end
