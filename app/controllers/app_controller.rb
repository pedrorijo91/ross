class AppController < ApplicationController

  def initialize
    super()
    @github = GithubService.new
  end

  def index
  end

  def stats
    username = params[:username]
    forced = if params['forced'] then true else false end
    Rails.logger.debug "Stats for #{username} (forced=#{forced})"

    stats = @github.fetch_user_stats(username, forced)

    render locals: {stats: stats}
  end

end
