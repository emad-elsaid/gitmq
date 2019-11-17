# frozen_string_literal: true

module GitMQ
  class Consumer
    def initialize(conf)
      @config = conf
      @storage = conf.storage
      @id = conf.id
    end

    def consume(branch, &block)
      storage.wait_branch branch
      label = "#{branch}-#{id}"

      loop do
        commit = storage.poll(branch, label)
        block.call commit.message
        storage.tag(label, commit)
      end
    end

    private

    attr_reader :config, :storage, :id
  end
end
