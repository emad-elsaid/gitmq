# frozen_string_literal: true

require_relative './lib/processor/printer'
require_relative './lib/logger/stdout'

CONFIG = {
  # logger instance
  logger: Gittt::Logger::Stdout.instance,

  # process events from these branches
  branches: [:master],

  # classes that subscribe to each branch
  subscriptions: {
    master: [Gittt::Processor::Printer]
  }
}.freeze
