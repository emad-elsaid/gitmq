# frozen_string_literal: true

require 'forwardable'
require 'ostruct'

module GitMQ
  class Config
    ATTRS = %i[
      storage
      id
    ].freeze

    DEFAULTS = {}.freeze

    extend Forwardable
    def_instance_delegators :@conf, *ATTRS

    def initialize(conf)
      full_conf = DEFAULTS.slice(*ATTRS).merge(conf)
      @conf = OpenStruct.new(full_conf)
    end
  end
end
