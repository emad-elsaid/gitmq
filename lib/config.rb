# frozen_string_literal: true

require_relative './logger/stdout'

module Gittt
  class Config
    attr_reader :subscriptions, :logger, :storage

    DEFAULTS = {
      subscriptions: [],
      logger: Logger::Stdout.new
    }.freeze

    def initialize(conf)
      full_conf = DEFAULTS.merge(conf)
      full_conf.each do |key, value|
        send("#{key}=", value)
      end
    end

    def branches
      subscriptions.keys
    end

    private

    attr_writer :subscriptions, :logger, :storage
  end
end
