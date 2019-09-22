class GithubService

  class Cache

    CACHE_TTL = 1.hours

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
      Rails.cache.write(key, value, expires_in: CACHE_TTL)
    end

    def self.write_nbr_forks(username, nbr_forks)
      write(cache_key_forks(username), nbr_forks)
    end

    def self.read_nbr_forks(username)
      read(cache_key_forks(username))
    end

    def self.read_or_write_user_stats(username, forced)
      Rails.cache.fetch(cache_key_user(username), expires_in: CACHE_TTL, force: forced) do
        yield # will execute computation block if there's no entry
      end
    end
  end

  private_constant :Cache

  def initialize

    if ENV['GITHUB_TOKEN']
      Octokit.configure{|c|
        c.access_token = ENV['GITHUB_TOKEN']
      }
    end

    @client = Octokit::Client.new

    @client.auto_paginate = true
    @scoring_rules = ScoringRules.new
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
    non_forks = public_repos.reject(&:fork)

    forks = public_repos.select(&:fork)
    Cache.write_nbr_forks(username, forks.size)

    non_forks.map do |repo|
      score = @scoring_rules.score_repo(repo.stargazers_count, repo.forks_count)
      RepoStats.new(repo.id, repo.name, repo.html_url, repo.stargazers_count, repo.forks_count, repo.language, score)
    end
  end

  def fetch_user_stats(username, forced = false)
    Cache.read_or_write_user_stats(username, forced) do
      Rails.logger.debug "No cache entry for #{username}, computing."
      compute_stats(username)
    end
  end

  private def fetch_user_orgs(username)
    # TODO https://github.com/pedrorijo91/ross-issues/issues/1 org_name -> repos (adapt erb)
    # @client.organizations(user = username).map {|org| org.login }
    []
  end

  private def compute_stats(username) # TODO https://github.com/pedrorijo91/ross-issues/issues/4 requests in parallel?
    Rails.logger.info "Computing user stats for #{username}"

    # TODO what if no user? https://github.com/pedrorijo91/ross-issues/issues/12

    repo_stats = fetch_repo_stats(username)
    nbr_forks = Cache.read_nbr_forks(username) # TODO https://github.com/pedrorijo91/ross-issues/issues/4 needs to be called after fetch_repo_stats
    nbr_stared = fetch_nbr_stared(username)
    user = fetch_user(username)
    orgs_user_belong = fetch_user_orgs(username)

    score = @scoring_rules.score_user(repo_stats, nbr_stared, nbr_forks)
    UserStats.new(user.id, username, user.name, user.html_url, user.avatar_url, repo_stats, nbr_stared, nbr_forks, orgs_user_belong, score)
  end
end