class AppController < ApplicationController

  def initialize
    super()
    @github = GithubService.new
  end

  def index; end

  def form_post
    if params[:username].blank?
      Rails.logger.warn 'No username received on request'
      redirect_to home_path, notice: 'Missing username'
    else
      redirect_to user_stats_path(params[:username])
    end
  end

  def stats
    username = params[:username]
    forced = params['forced'] ? true : false

    Rails.logger.debug "Stats for #{username} (forced=#{forced})"

    stats = @github.fetch_user_stats(username, forced)

    if stats.nil? # as for now, if we return nil it means username does not exist.
      redirect_to home_path, alert: "Invalid username: #{username}. The submitted username doesn't seem to exist on GitHub"
    else
      render locals: { stats: stats }
    end

  end

end
