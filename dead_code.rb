require 'find'


classes = []
Find.find('./app/', './lib/') do |path|
  if FileTest.file?(path) and path.end_with? '.rb'
    File.open(path, 'r').each do |line|
      if line =~ /^class\s+(\w+)/
        match = $1
        next if match =~ /Controller$/
        classes << match
      end
    end
  end
end


found = []
Find.find('./app/', './lib/', './db', './script', './config') do |path|
  if FileTest.file?(path) and (path.end_with? '.rb' or path.end_with? '.yml' or path.end_with? '.erb' or path.end_with? '.rake')
    classes.each do |klass|
      unless (File.open(path, 'r').grep /\b#{klass}\./).empty?
        found << klass        
      end
    end
  end
end


found.uniq!


puts classes - found
