# frozen_string_literal: true

require 'logger'
require 'singleton'

module Gittt
  module Logger
    class Stdout < ::Logger
      include Singleton

      def initialize
        super(STDOUT)
      end
    end
  end
end
