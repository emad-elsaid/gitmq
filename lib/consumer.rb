# frozen_string_literal: true

require_relative './storage'
require_relative './subscriptions'

module Gittt
  class Consumer
    def initialize(conf)
      @config = conf
      @subscriptions = Subscriptions.new
      subscribe
    end

    def read
      config.branches.map { |branch| branch_thread(branch) }.map(&:join)
    rescue Interrupt
      logger.info 'Bye.'
    end

    private

    attr_reader :config, :subscriptions

    def logger
      config.logger
    end

    def branch_thread(branch)
      Thread.new do
        loop do
          event = Gittt::Storage.instance.poll(branch)
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
