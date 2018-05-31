class GithubService

  def initialize
    @client = Octokit::Client.new
    @client.auto_paginate = true
  end

  private def fetch_public_repos(username)
    @client.repositories(user = username)
  end

  private def compute_repo_stats(username)
    puts "Computing repo stats for #{username}" # FIXME logger

    public_repos = fetch_public_repos(username)
    non_forks = public_repos.select { |repo| !repo.fork }

    non_forks.map { |repo| RepoStats.new(repo.id, repo.name, repo.html_url, repo.stargazers_count, repo.forks_count)}
  end

  private def cache_key(username)
    "github_cache_key/#{username}"
  end

  def fetch_repo_stats(username)

    Rails.cache.fetch(cache_key(username), expires_in: 1.hours) do
      compute_repo_stats(username)
    end

  end
end