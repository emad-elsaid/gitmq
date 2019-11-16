# frozen_string_literal: true

require_relative './logger/stdout'

module GitMQ
  class Config
    attr_reader :logger, :storage

    DEFAULTS = {
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

    attr_writer :logger, :storage
  end
end
