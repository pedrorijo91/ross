class AppController < ApplicationController

  def index
  end

  def stats
    username = params[:username]
    puts "USERNAME: #{username}"

    # TODO use github service
    Octokit.auto_paginate = true
    public_repos = Octokit.repositories(user = username)
    non_forks = public_repos.select { |repo| !repo.fork }

    puts public_repos.length
    puts non_forks.length

    stats = non_forks.map { |repo| RepoStats.new(repo.id, repo.name, repo.html_url, repo.stargazers_count, repo.forks_count)}

    render locals: {username: username, repos: stats}
  end

end
