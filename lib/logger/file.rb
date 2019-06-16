# frozen_string_literal: true

require 'logger'

module Gittt
  module Logger
    class File < ::Logger
      def initialize(path)
        super(path)
      end
    end
  end
end
