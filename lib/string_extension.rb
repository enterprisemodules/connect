if RUBY_VERSION < '1.9.2'
  #
  # This is class extenstion which provides missing :% method for older Ruby.
  #
  class String
    old_format = instance_method(:%)

    define_method(:%) do |arg|
      if arg.is_a?(Hash)
        gsub(/%\{(.*?)\}/) { arg[Regexp.last_match(1).to_sym] }
      else
        old_format.bind_call(self, arg)
      end
    end
  end
end
