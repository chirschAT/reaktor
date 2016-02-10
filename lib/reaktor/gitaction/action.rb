require 'logger'
require 'r10k'
require 'git'
require 'notification/notifier'

module Reaktor
module GitAction
  class Action
    include R10K::Deploy
    attr_accessor :module_name,
    :git_url,
    :branch_name,
    :puppetfile,
    :logger

    def initialize(options = {})
      @options = options
      if module_name = options[:module_name]
        @module_name = module_name
      end
      if git_url = options[:git_url]
        @git_url = git_url
      end
      if branch_name = options[:branch_name]
        @branch_name = branch_name
      end
      if logger = options[:logger]
        @logger = logger
      else
        @logger = Logger.new(STDOUT)
      end
    end
  end
end
end
   


