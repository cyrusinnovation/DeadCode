module DeadCode

  class Modules < Interface

    private
    def match_definition line
      line =~ /^module\s+(\w+)/ ? $1 : nil
    end

    def definition_keyword
      "module"
    end

    def is_used? file_path, klass, use_rails
      !(File.open(file_path, 'r').grep(/include\s*#{klass}/).empty? &&
          File.open(file_path, 'r').grep(/#{klass}::/).empty?)
    end
  end

end