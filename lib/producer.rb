# frozen_string_literal: true

module GitMQueue
  class Producer
    def initialize(storage:, branch:)
      @storage = storage
      @branch = branch
    end

    def publish(event)
      commit = Rugged::Commit.create(
        @storage.repo,
        tree: @storage.tree,
        message: event.to_s,
        parents: [@storage.branch(@branch)&.target].compact
      )
      @storage.branches.create(@branch, commit, force: true)
    end
  end
end
