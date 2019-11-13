# frozen_string_literal: true

require 'logger'

module GitMQ
  module Logger
    class File < ::Logger
      def initialize(path)
        super(path)
      end
    end
  end
end
