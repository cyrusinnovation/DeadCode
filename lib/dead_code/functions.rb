
module DeadCode

  class Functions < Interface

    private
    def match_definition line
      line =~ method_definition_regex ? $2 : nil
    end

    def is_used? file_path, function, use_rails
      escaped_function = function.gsub '?', '\?'
      usages = File.open(file_path, 'r').grep(/(?:^|\W+)#{escaped_function}(?:\W+|$)/) do |line|
        return true unless line =~ method_definition_regex
      end
      false
    end

    def definition_keyword
      "def"
    end

    def remove_unused
      @unused.delete 'initialize'
      @unused.delete 'method_missing'
    end

    def method_definition_regex
      /def\s+(self\.)?(\w+\??)/
    end

  end

end