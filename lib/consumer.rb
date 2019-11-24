# frozen_string_literal: true

module GitMQueue
  class Consumer
    def initialize(storage:, name:, branch:)
      @storage = storage
      @branch = branch
      @name = name
      @label = "#{branch}.#{name}"
    end

    def consume(&block)
      @storage.wait_branch @branch

      loop do
        commit = @storage.poll(@branch, @label)
        block.call commit.message
        @storage.tag(@label, commit)
      end
    end
  end
end
