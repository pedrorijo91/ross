class AppController < ApplicationController

  def initialize
    super()
    @github = GithubService.new
  end

  def index
  end

  def stats
    username = params[:username]
    puts "USERNAME: #{username}" # FIXME logger

    stats = @github.fetch_user_stats(username)

    render locals: {stats: stats}
  end

  def mockup
    # username = params[:username]
    username = "pedrorijo91"

    forced = if params['forced'] then true else false end
    puts "USERNAME: #{username}" # FIXME logger

    stats = @github.fetch_user_stats(username, forced)

    render locals: {stats: stats}
  end

end
