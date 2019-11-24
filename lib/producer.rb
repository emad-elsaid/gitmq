# frozen_string_literal: true

module GitMQ
  class Producer
    def initialize(storage:)
      @storage = storage
    end

    def publish(branch, event)
      commit = Rugged::Commit.create(
        @storage.repo,
        tree: @storage.tree,
        message: event.to_s,
        parents: [@storage.branch(branch)&.target].compact
      )
      @storage.branches.create(branch, commit, force: true)
    end
  end
end
