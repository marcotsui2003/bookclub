class ReadersController < ApplicationController

	get '/signup' do
		if logged_in?
			redirect '/books'
		end
		erb :"readers/create_reader"
	end

	post '/signup' do
		if params[:username].empty?||params[:password].empty?||params[:email].empty?
			redirect '/signup'
		else
			@reader = Reader.create(params)
			session[:id]= @reader.id
			redirect '/books'
		end
	end

	get '/login' do
		@error=params[:error]
		if logged_in?
			redirect '/books'
		end
		erb :login
	end

	post '/login' do
		@reader =Reader.find_by(:username=> params[:username])
		
		if @reader && @reader.authenticate(params[:password])
			session[:id] = @reader.id
			redirect '/books'
		else
			redirect '/login'
		end
	end

	get '/logout' do
		if !session[:id].nil?
			session.clear
			redirect '/login'
		else
			redirect '/'
		end
	end

end