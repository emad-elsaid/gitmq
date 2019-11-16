# frozen_string_literal: true

require_relative './subscriptions'

module GitMQ
  class Consumer
    def initialize(conf)
      @config = conf
      @storage = conf.storage
    end

    def consume(branch, &block)
      storage.wait_branch branch

      loop do
        event = storage.poll branch
        block.call event
      end
    end

    private

    attr_reader :config, :storage
  end
end
