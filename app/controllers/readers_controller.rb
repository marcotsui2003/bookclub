class ReadersController < ApplicationController

	#can't use before filter for redirect_if_logged_in - will cause infinite loop
	#not sure why

	get '/signup' do
		redirect_if_logged_in
		erb :"readers/create"
	end

	post '/signup' do
    redirect_if_logged_in
		@reader = Reader.new(params)
		if @reader.save
	    session[:id] = @reader.id
			flash[:notice] = "Account successfully created, welcome #{@reader.username}!"
			redirect '/books'
		else
			flash[:errors] = @reader.errors.full_messages
			redirect '/signup'
		end
	end

	get '/login' do
		redirect_if_logged_in
		erb :login
	end

	post '/login' do
		redirect_if_logged_in
		@reader =Reader.find_by(:username=> params[:username])
		if @reader && @reader.authenticate(params[:password])
			session[:id] = @reader.id
			flash[:notice] = "You have successfully logged in, #{@reader.username}!"
			redirect '/books'
		else
			if @reader
				flash[:errors] = ["Invalid password."]
				redirect '/'
			else
				flash[:errors] = ["No such user exists."]
				redirect '/'
			end
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
