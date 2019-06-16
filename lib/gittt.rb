# frozen_string_literal: true

require_relative './storage'
require_relative './subscriptions'

module Gittt
  module_function

  def config
    @config
  end

  def config=(conf)
    @config = conf
    subscribe(conf.subscriptions)
  end

  def read
    config.branches.map { |branch| branch_thread(branch) }.map(&:join)
  rescue Interrupt
    logger.info 'Bye.'
  end

  def logger
    config.logger
  end

  def branch_thread(branch)
    Thread.new do
      loop do
        event = Gittt::Storage.instance.pull(branch)
        Gittt::Subscriptions.instance.process(branch, event)
      end
    end
  end

  def subscribe(subscriptions)
    subscriptions.each do |branch, subscribers|
      subscibe_to_branch(branch, subscribers)
    end
  end

  def subscibe_to_branch(branch, subscribers)
    subscribers.each do |subscriber|
      Subscriptions.instance.subsribe(branch, subscriber)
    end
  end
end
