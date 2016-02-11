module Reaktor
  module Jobs
    class ModifyEvent
      include Event

      @queue = :resque_modify
      @logger ||= Logger.new(STDOUT, Logger::INFO)

      def self.perform(module_name, branch_name)
        git_urls = ENV['PUPPETFILE_GIT_URLS'].split(' ')
        unless git_urls.nil? or git_urls.empty?
          git_urls.sort.each do |git_url|
            @options = { :module_name => module_name,
                         :git_url     => git_url,
                         :branch_name => branch_name,
                         :logger => @logger
                       }
            Redis::Lock.new(branch_name, :expiration => 60).lock do
              # do your stuff here ...
              action = Reaktor::GitAction::ModifyAction.new(@options)
              action.setup
              action.updatePuppetfile
              action.cleanup
            end
          end
          Notification::Notifier.instance.notification = "r10k deploy module for #{module_name} in progress..."
          r10k_deploy_module module_name
          Notification::Notifier.instance.notification = "r10k deploy module for #{module_name} finished"
        end
      end
    end
  end
end
