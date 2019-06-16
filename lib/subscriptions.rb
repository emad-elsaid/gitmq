# frozen_string_literal: true

require 'set'
require 'singleton'

module Gittt
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
        logger.error("#{subscriber}(#{event}) -> #{exp}")
      end
    end

    private

    attr_reader :subs

    def branch_subs(branch)
      subs[branch] ||= Set.new
    end
  end
end
