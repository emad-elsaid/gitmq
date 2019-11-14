# frozen_string_literal: true

module GitMQ
  class Producer
    def initialize(conf)
      @config = conf
      @storage = conf.storage
    end

    def publish(branch, event)
      options = {
        tree: storage.tree,
        message: event.to_s,
        parents: [storage.branch(branch)&.target].compact
      }

      commit = Rugged::Commit.create(storage.repo, options)
      storage.repo.branches.create(branch, commit, force: true)
    end

    private

    attr_reader :config, :storage
  end
end
