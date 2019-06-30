# frozen_string_literal: true

require 'singleton'

module Gittt
  class Storage
    def initialize
      @queues = {}
    end

    def publish(branch, event)
      init_branch(branch)
      @queues[branch] << event
    end

    def poll(branch)
      init_branch(branch)
      @queues[branch].pop
    end

    private

    def init_branch(branch)
      @queues[branch] ||= Queue.new
    end
  end
end
