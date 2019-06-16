# frozen_string_literal: true

require 'set'
require 'singleton'
require_relative './loggers/stdout_logger'

class Subscriptions
  include Singleton

  def initialize
    @subs = {}
  end

  def subsribe(branch, subscriber)
    @subs[branch] ||= Set.new
    @subs[branch] << subscriber
  end

  def process(branch, event)
    @subs.fetch(branch, []).each do |subscriber|
      subscriber.call(event)
    rescue StandardError => e
      StdoutLogger.instance.error("#{subscriber}(#{event}) -> #{e}")
    end
  end
end
