# frozen_string_literal: true

require_relative './that/print'

CONFIG = {
  branches: [:master],
  subscriptions: {
    master: [Printer]
  }
}.freeze
