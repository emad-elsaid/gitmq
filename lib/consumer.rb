# frozen_string_literal: true

module GitMQ
  class Consumer
    def initialize(storage:, name:)
      @storage = storage
      @name = name
    end

    def consume(branch, &block)
      @storage.wait_branch branch
      label = "#{branch}-#{@name}"

      loop do
        commit = @storage.poll(branch, label)
        block.call commit.message
        @storage.tag(label, commit)
      end
    end
  end
end
