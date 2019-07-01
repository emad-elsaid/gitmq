# frozen_string_literal: true

require 'forwardable'
require 'fileutils'
require 'rugged'

module Gittt
  class Storage
    extend Forwardable

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
      Queue.new.pop
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
  end
end
