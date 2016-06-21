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
        flash[:errors] = ["You need to log in to perform this function."]
        redirect "/login"
      end
    end

    def redirect_if_logged_in
      if logged_in?
        flash[:errors] = ["You have already logged in."]
        redirect '/books'
      end
    end

    def logged_in?
      !!current_reader
    end

    def current_reader
      @current_reader ||= Reader.find_by(id: session[:id])
      #@test = 3 totally screwed things up
    end

    def review_helper(rating)
      rating.blank? ? "No rating was given." : rating
    end

    def reviewer_name(name)
      name == current_reader.username ? "You" : name
    end
  end

  get '/' do
    redirect_if_logged_in
  	erb :index
	end

end
