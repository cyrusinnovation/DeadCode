require 'find'

class DeadCode

  def initialize
    @classes = {}
  end

  def find_classes file_path
    File.open(file_path, 'r').each_with_index do |line, line_number|
      if line =~ /^class\s+(\w+)/
        match = $1
        next if match =~ /Controller$/
        @classes[match] = "#{file_path}:#{line_number}"
      end
    end
    @classes.keys
  end

  def find_files root_path
    files = []
    Find.find(root_path) do |path|
      files << path if path =~ /\.rb$/
    end
    files
  end

    #NOT DONE
  def find_rails_files rails_root
    find_files "#{rails_root}/app/"
    find_files "#{rails_root}/lib/"
  end
end

#    

# found = []
# Find.find('./app/', './lib/', './db', './script', './config') do |path|
#   if FileTest.file?(path) and (path.end_with? '.rb' or path.end_with? '.yml' or path.end_with? '.erb' or path.end_with? '.rake')
#     classes.keys do |klass|
#       unless (File.open(path, 'r').grep /\b#{klass}\./).empty?
#         found << klass        
#       end
#     end
#   end
# end


# found.uniq!
# results = classes.keys - found

# results.each do |klass|
# #  puts "#{klass} was found at #{classes[klass]}, but was unused."
# end
