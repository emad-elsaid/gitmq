# frozen_string_literal: true

require 'fileutils'
require 'rugged'

module GitMQueue
  class Storage
    attr_reader :repo, :path

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

    def commits(branch, tag)
      walker = Rugged::Walker.new(repo)
      walker.sorting(Rugged::SORT_TOPO | Rugged::SORT_REVERSE)
      walker.push(branch(branch).target)

      tag = repo.tags[tag]
      walker.hide(tag.target) if tag
      walker
    end

    def tag(label, commit)
      repo.tags.create(label, commit, true)
    end

    private

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
