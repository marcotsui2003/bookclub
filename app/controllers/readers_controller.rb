class ReadersController < ApplicationController

	get '/signup' do
		if logged_in?
			redirect '/books'
		end
		erb :"readers/create"
	end

	post '/signup' do
    # refactor this
		@reader = Reader.new(params)
		if @reader.save
			flash[:notice] = "Account successfully created."
	    session[:id] = @reader.id
			redirect '/books'
		else
			flash[:errors] = @reader.errors.full_messages
			redirect '/signup'
		end
	end

		#if params[:username].empty?||params[:password].empty?||params[:email].empty?
		#	redirect '/signup'
		#else
		#	@reader = Reader.create(params)
		#	session[:id]= @reader.id
		#	redirect '/books'
		#end


	get '/login' do
		if logged_in?
			redirect '/books'
		end
		erb :login
	end

	post '/login' do
		@reader =Reader.find_by(:username=> params[:username])

		if @reader && @reader.authenticate(params[:password])
			session[:id] = @reader.id
			flash[:notice] = "You have successfully logged in."
			redirect '/books'
		else
			flash[:errors] = ["Username and password do not match."]
			redirect '/login'
		end
	end

	get '/logout' do
		if !session[:id].nil?
			session.clear
			flash[:notice]= "You have successfully logged out."
			redirect '/'
		else
			redirect '/'
		end
	end

end
