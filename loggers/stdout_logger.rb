# frozen_string_literal: true

class StdoutLogger
  include Singleton

  def initialize
    super(STDOUT)
  end
end
