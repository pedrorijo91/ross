class GithubService

  class Cache
    private_class_method def self.cache_key_user(username)
      "github_cache_key/#{username}"
    end

    private_class_method def self.cache_key_forks(username)
      "github_cache_key_forks/#{username}"
    end

    private_class_method def self.read(key)
      Rails.cache.read(key)
    end

    private_class_method def self.write(key, value)
      Rails.cache.write(key, value, expires_in: 1.hours)
    end

    def self.write_nbr_forks(username, nbr_forks)
      write(cache_key_forks(username), nbr_forks)
    end

    def self.read_nbr_forks(username)
      read(cache_key_forks(username))
    end

    def self.read_or_write_user_stats(username)
      Rails.cache.fetch(cache_key_user(username), expires_in: 1.hours) do
        yield
      end
    end
  end

  private_constant :Cache

  def initialize
    @client = Octokit::Client.new
    @client.auto_paginate = true
  end

  private def fetch_public_repos(username)
    @client.repositories(user = username)
  end

  private def fetch_nbr_stared(username)
    @client.starred(user = username).size
  end

  private def fetch_user(username)
    @client.user(user = username)
  end

  private def fetch_repo_stats(username)
    public_repos = fetch_public_repos(username)
    non_forks = public_repos.select { |repo| !repo.fork }

    forks = public_repos.select { |repo| repo.fork }
    Cache.write_nbr_forks(username, forks.size)

    non_forks.map { |repo| RepoStats.new(repo.id, repo.name, repo.html_url, repo.stargazers_count, repo.forks_count, repo.language)}
  end

  def fetch_user_stats(username)
    Cache.read_or_write_user_stats(username) do
      puts "Computing user stats for #{username}"
      repo_stats = fetch_repo_stats(username)
      nbr_stared = fetch_nbr_stared(username)
      user = fetch_user(username)
      nbr_forks = Cache.read_nbr_forks(username)

      UserStats.new(user.id, username, user.html_url, user.avatar_url, repo_stats, nbr_stared, nbr_forks)
    end

  end
end