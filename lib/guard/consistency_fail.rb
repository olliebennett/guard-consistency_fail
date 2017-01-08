require 'guard'

module Guard
  class ConsistencyFail < Plugin

    # Allowable options are:
    # :environment        defaults to 'development'

    def initialize(options = {})
      @options = {
        run_on_start: true
      }.merge(options)
      @watchers = options[:watchers]
      super
    end

    def start
      run_all if @options[:run_on_start]
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
