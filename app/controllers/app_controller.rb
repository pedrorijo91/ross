class AppController < ApplicationController

  def initialize
    @github = GithubService.new
  end

  def index
  end

  def stats
    username = params[:username]
    puts "USERNAME: #{username}" # FIXME logger

    stats = @github.fetch_repo_stats(username)

    render locals: {username: username, repos: stats}
  end

end
