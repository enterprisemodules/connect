require 'byebug'

module ::Guard
  class Racc < Plugin
    def run_all

    end

    def run_on_modifications(paths)
      raise ArgumentError, 'Racc guard support only compilation of singe file' if paths.size > 1
      input_file = Pathname.new(paths.first)
      dir = input_file.dirname
      output_file = dir + 'parser.rb'
      UI.info "Running Racc on #{input_file}"
      `racc #{input_file} -v -o #{output_file}`
    end
  end
end

module ::Guard
  class Rex < Plugin
    def run_all

    end

    def run_on_modifications(paths)
      raise ArgumentError, 'Rex guard support only compilation of singe file' if paths.size > 1
      input_file = Pathname.new(paths.first)
      dir = input_file.dirname
      output_file = dir + 'lexer.rb'
      UI.info "Running Rex on #{input_file}"
      `rex #{input_file} -o #{output_file}`
    end
  end
end


guard :rex do
  watch(%r{^lib\/(.*)\/(.+)\.rex$})
end

guard :racc do
  watch(%r{^lib\/(.*)\/(.+)\.y$})
end


guard :rspec, cmd: "rspec" do
  watch(%r{^spec/(.+)/.+_spec\.rb$})
  watch(%r{^lib\/(.*)\/(.+)\.rb$})     { |m| "spec/unit/#{m[1]}/#{m[2]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end


guard :bundler do
  watch('Gemfile')
  # Uncomment next line if Gemfile contain `gemspec' command
  # watch(/^.+\.gemspec/)
end