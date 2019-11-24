# frozen_string_literal: true

require 'fileutils'
require 'rugged'

module GitMQ
  class Storage
    WAIT_NON_EXISTING_BRANCH = 1 # seconds
    WAIT_FOR_COMMIT = 1 # seconds

    attr_reader :repo

    def initialize(path)
      @path = path
      @repo = read_or_create_repo
    end

    def branches
      repo.branches
    end

    def branch(name)
      branches[name]
    end

    def tree
      Rugged::Tree::Builder.new(repo).write
    end

    def poll(branch, tag)
      wait_for_commit(branch, tag)

      walker = Rugged::Walker.new(repo)
      walker.sorting(Rugged::SORT_TOPO | Rugged::SORT_REVERSE)
      walker.push(repo.branches[branch].target)
      walker.hide(repo.tags[tag].target) if repo.tags[tag]

      walker.first
    end

    def tag(label, commit)
      repo.tags.create(label, commit, true)
    end

    def wait_branch(branch)
      sleep WAIT_NON_EXISTING_BRANCH until repo.branches.exist?(branch)
    end

    private

    attr_reader :path

    def read_or_create_repo
      FileUtils.mkdir_p(path) unless File.exist?(path)
      begin
        Rugged::Repository.new(path)
      rescue Rugged::RepositoryError
        Rugged::Repository.init_at(path, :bare)
      end
    end

    def wait_for_commit(branch, tag)
      sleep WAIT_FOR_COMMIT until branch(branch).target.oid != repo.tags[tag]&.target&.oid
    end
  end
end
