require 'guard'

module Guard
  class ConsistencyFail < Plugin

    # Allowable options are:
    # :environment - defaults to 'development'
    # :run_on_start - whether to run when Guard starts up

    def initialize(options = {})
      puts "initialize..."
      puts options
      @options = {
        run_on_start: true
      }.merge(options)
      puts "merged:"
      puts @options
      @watchers = options[:watchers]
      puts 'calling super...'
      super
    end

    def start
      puts "start..."
      puts @options

      run_all unless @options[:run_on_start] == false
    end

    # Called on Ctrl-C signal (when Guard quits)
    def stop
    end

    # Called on Ctrl-Z signal
    # This method should be mainly used for "reload" (really!) actions like reloading passenger/spork/bundler/...
    def reload
      run_all
    end

    # Called on Ctrl-/ signal
    # This method should be principally used for long action like running all specs/tests/...
    def run_all
      system(cmd)
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      puts "#" * 99
      puts "files changes: #{paths}"
      run_all
    end

    private

    def cmd
      command = 'consistency_fail'
      command = "export RAILS_ENV=#{@options[:environment]}; #{command}" if @options[:environment]
      Compat::UI.info "Running consistency_fail: #{command}"
      command
    end
  end
end
