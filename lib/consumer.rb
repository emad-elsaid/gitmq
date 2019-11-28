# frozen_string_literal: true

require 'listen'

module GitMQ
  class Consumer
    def initialize(storage:, name:, branch:)
      @storage = storage
      @branch = branch
      @name = name
    end

    def branch_file
      @branch_file ||= File.join(@storage.path, 'refs', 'heads')
    end

    def consume(&block)
      @block = block
      consume_commits
      listener.start
    end

    def stop
      listener.stop
    end

    private

    def listener
      @listener ||= Listen.to(branch_file, only: /#{Regexp.escape(@branch)}/) do
        consume_commits
      end
    end

    def consume_commits
      commits = @storage.commits(@branch, @name)
      commits.each do |commit|
        @block.call commit.message
        @storage.tag(@name, commit)
      end
    end
  end
end
