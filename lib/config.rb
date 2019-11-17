# frozen_string_literal: true

require 'logger'
require 'forwardable'
require 'ostruct'

module GitMQ
  class Config
    ATTRS = %i[
      logger
      storage
      id
    ].freeze

    DEFAULTS = {
      logger: Logger.new(STDOUT)
    }.freeze

    extend Forwardable
    def_instance_delegators :@conf, *ATTRS

    def initialize(conf)
      full_conf = DEFAULTS.slice(*ATTRS).merge(conf)
      @conf = OpenStruct.new(full_conf)
    end
  end
end
