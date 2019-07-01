# frozen_string_literal: true

require_relative './lib/processor/printer'
require_relative './lib/logger/stdout'
require_relative './lib/storage'

CONFIG = {
  # logger instance
  logger: Gittt::Logger::Stdout.new,

  # set where to store data
  storage: Gittt::Storage.new('/tmp/gittt_storage'),

  # classes that subscribe to each branch
  subscriptions: {
    'master' => [Gittt::Processor::Printer]
  }
}.freeze
