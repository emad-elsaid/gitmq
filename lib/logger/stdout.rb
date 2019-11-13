# frozen_string_literal: true

require 'logger'

module GitMQ
  module Logger
    class Stdout < ::Logger
      def initialize
        super(STDOUT)
      end
    end
  end
end
