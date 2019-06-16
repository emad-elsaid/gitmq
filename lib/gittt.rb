# frozen_string_literal: true

require_relative './logger/stdout'
require_relative './storage'
require_relative './subscriptions'

module Gittt
  module_function

  def read
    @branches.map { |branch| branch_thread(branch) }.map(&:join)
  rescue Interrupt
    logger.info 'Exiting...'
  end

  def branch_thread(branch)
    Thread.new do
      loop do
        event = Gittt::Storage.instance.pull(branch)
        Gittt::Subscriptions.instance.process(branch, event)
      end
    end
  end

  def logger
    @logger.instance
  end

  def config=(conf)
    subscribe(conf.fetch(:subscriptions, {}))
    @logger = conf.fetch(:logger, Logger::Stdout)
    @branches = conf.fetch(:branches, [])
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
