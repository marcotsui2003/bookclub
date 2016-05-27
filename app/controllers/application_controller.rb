require './config/environment'

class ApplicationController < Sinatra::Base

  register Sinatra::Flash
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'super crazy secret'
  end

  helpers do
    def redirect_if_not_logged_in
      if !logged_in?
        redirect "/login?error=You have to be logged in to do that"
      end
    end

    def logged_in?
      !!current_reader
    end

    def current_reader
      @current_reader ||= Reader.find_by(id: session[:id])
      #@test = 3 totally screwed things up
    end

  end

  get '/' do
  	erb :index
	end


end
