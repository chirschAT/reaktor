require 'gitaction/create_action'
require 'logger'

module Reaktor
  module Jobs
    class CreateEvent
      include Event

      @queue   = :resque_create
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
            Redis::Lock.new(branch_name, :expiration => 300).lock do
              # do your stuff here ...
              action = Reaktor::GitAction::CreateAction.new(@options)
              action.setup
              action.updatePuppetFile
              action.cleanup
            end
          end
        end
      end
    end
  end
end
