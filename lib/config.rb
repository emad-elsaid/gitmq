# frozen_string_literal: true

require 'forwardable'
require 'ostruct'

require_relative './logger/stdout'

module GitMQ
  class Config
    ATTRS = %i[
      logger
      storage
      id
    ].freeze

    DEFAULTS = {
      logger: Logger::Stdout.new
    }.freeze

    extend Forwardable
    def_instance_delegators :@conf, *ATTRS

    def initialize(conf)
      full_conf = DEFAULTS.slice(*ATTRS).merge(conf)
      @conf = OpenStruct.new(full_conf)
    end
  end
end
