class AppController < ApplicationController

  def index
  end

  def stats
    @username = params[:username]
    puts "USERNAME: #{@username}"

    render locals: { :username => @username }
  end

end
