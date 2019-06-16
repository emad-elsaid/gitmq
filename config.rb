# frozen_string_literal: true

require_relative './lib/processor/printer'

CONFIG = {
  branches: [:master],
  subscriptions: {
    master: [Gittt::Processor::Printer]
  }
}.freeze
