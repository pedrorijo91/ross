class GithubService

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
    puts "Computing repo stats for #{username}"

    public_repos = fetch_public_repos(username)
    non_forks = public_repos.select { |repo| !repo.fork }

    forks = public_repos.select { |repo| repo.fork }
    Rails.cache.write(cache_key_forks(username), forks.size)

    non_forks.map { |repo| RepoStats.new(repo.id, repo.name, repo.html_url, repo.stargazers_count, repo.forks_count, repo.language)}
  end

  private def cache_key_user(username)
    "github_cache_key/#{username}"
  end

  private def cache_key_forks(username)
    "github_cache_key_forks/#{username}"
  end

  def fetch_user_stats(username)
    Rails.cache.fetch(cache_key_user(username), expires_in: 1.hours) do
      repo_stats = fetch_repo_stats(username)
      nbr_stared = fetch_nbr_stared(username)
      user = fetch_user(username)
      nbr_forks = Rails.cache.read(cache_key_forks(username))

      UserStats.new(user.id, username, user.html_url, user.avatar_url, repo_stats, nbr_stared, nbr_forks)
    end
  end
end