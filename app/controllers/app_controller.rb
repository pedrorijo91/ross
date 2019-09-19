class AppController < ApplicationController

  def initialize
    super()
    @github = GithubService.new
  end

  def index; end

  def form_post
    redirect_to user_stats_path(params[:username])
  end

  def stats
    username = params[:username]
    forced = params['forced'] ? true : false
    Rails.logger.debug "Stats for #{username} (forced=#{forced})"

    stats = @github.fetch_user_stats(username, forced)

    render locals: { stats: stats }
  end

end
