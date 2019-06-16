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
    branch_subs(branch) << subscriber
  end

  def process(branch, event)
    subs.fetch(branch, []).each do |subscriber|
      subscriber.call(event)
    rescue StandardError => exp
      StdoutLogger.instance.error("#{subscriber}(#{event}) -> #{exp}")
    end
  end

  private

  attr_reader :subs

  def branch_subs(branch)
    subs[branch] ||= Set.new
  end
end
