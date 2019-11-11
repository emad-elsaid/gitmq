# frozen_string_literal: true

require 'forwardable'
require 'fileutils'
require 'rugged'

module Gittt
  class Storage
    extend Forwardable

    WAIT_NON_EXISTING_BRANCH = 1 # seconds
    WAIT_FOR_COMMIT = 1 # seconds

    def initialize(path)
      @path = path
      @repo = read_or_create_repo
    end

    def publish(branch, event)
      options = {
        tree: Rugged::Tree::Builder.new(repo).write,
        message: event.to_s,
        parents: [repo.branches[branch]&.target].compact
      }

      commit = Rugged::Commit.create(repo, options)
      repo.branches.create(branch, commit, force: true)
    end

    def poll(branch)
      wait_for_branch(branch)
      wait_for_commit(branch, @last_polled)

      walker = Rugged::Walker.new(repo)
      walker.push(repo.branches[branch].target)

      @last_polled = walker.first
      @last_polled.message
    end

    private

    attr_reader :path, :repo
    def_delegator :@repo, :branches

    def read_or_create_repo
      FileUtils.mkdir_p(path) unless File.exist?(path)
      begin
        Rugged::Repository.new(path)
      rescue Rugged::RepositoryError
        Rugged::Repository.init_at(path, :bare)
      end
    end

    def wait_for_branch(branch)
      sleep WAIT_NON_EXISTING_BRANCH until repo.branches.exist?(branch)
    end

    def wait_for_commit(branch, last_polled)
      sleep WAIT_FOR_COMMIT until repo.branches[branch].target.oid != last_polled&.oid
    end
  end
end
