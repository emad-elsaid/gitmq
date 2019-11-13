# frozen_string_literal: true

require_relative './lib/processor/printer'
require_relative './lib/logger/stdout'
require_relative './lib/storage'

CONFIG = {
  # logger instance
  logger: GitMQ::Logger::Stdout.new,

  # set where to store data
  storage: GitMQ::Storage.new('/tmp/gittt_storage'),

  # classes that subscribe to each branch
  subscriptions: {
    'master' => [GitMQ::Processor::Printer]
  }
}.freeze
