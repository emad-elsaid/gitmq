# frozen_string_literal: true

module GitMQ
  module Processor
    class Printer
      def self.call(event)
        puts event
      end
    end
  end
end
