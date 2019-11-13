# frozen_string_literal: true

require 'set'

module GitMQ
  class Subscriptions
    def initialize
      @subs = {}
    end

    def subsribe(branch, subscribers)
      branch_subs(branch).merge Array(subscribers)
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
