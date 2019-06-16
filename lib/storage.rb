# frozen_string_literal: true

require 'singleton'

module Gittt
  class Storage
    include Singleton

    def initialize
      @queues = {}
    end

    def publish(branch, event)
      init_branch(branch)
      @queues[branch] << event
    end

    def pull(branch)
      init_branch(branch)
      @queues[branch].pop
    end

    private

    def init_branch(branch)
      @queues[branch] ||= Queue.new
    end
  end
end
