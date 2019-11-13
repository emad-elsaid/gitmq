# frozen_string_literal: true

require_relative './subscriptions'

module GitMQ
  class Consumer
    def initialize(conf)
      @config = conf
      @subscriptions = Subscriptions.new
      @storage = conf.storage
      subscribe
    end

    def start
      config.branches.map { |branch| branch_thread(branch) }.map(&:join)
    rescue Interrupt
      logger.info 'Bye.'
    end

    private

    attr_reader :config, :subscriptions, :storage

    def logger
      config.logger
    end

    def branch_thread(branch)
      Thread.new do
        loop do
          event = storage.poll(branch)
          subscriptions.process(branch, event)
        end
      end
    end

    def subscribe
      config.subscriptions.each do |branch, subscribers|
        subscriptions.subsribe(branch, subscribers)
      end
    end
  end
end
