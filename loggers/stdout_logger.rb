# frozen_string_literal: true

require 'logger'
require 'singleton'

class StdoutLogger < Logger
  include Singleton

  def initialize
    super(STDOUT)
  end
end
