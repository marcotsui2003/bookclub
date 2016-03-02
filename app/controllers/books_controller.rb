require 'pry'

class BooksController < ApplicationController
	get '/books' do
		redirect_if_not_logged_in
		
		@reader= Reader.find(session[:id])
		@reader_books =@reader.books
		@other_books = @reader.books_read_by_others
		erb :"/books/books"
		
	end

	get '/books/new' do
		redirect_if_not_logged_in
		@error = params[:error]
		
		if !params[:title].nil?
			@title= params[:title]
		else
			@title= nil
		end


		erb :'/books/create_book'
	end

	post '/books' do
		if params[:title].empty?
			redirect "/books/new?error=You need to type in the book's title"
		end

		@reader= current_reader
		
		if @reader.books.exists?(title: params[:title])
			redirect '/books?error=This book is already in your reading list.'#should redirect to the book edit page
		end

		
		@book =Book.create(title: params[:title])
		if !params[:category].empty?
			params[:category].split(",").each do |c|
		  	@book.categories.create(name: c, reader_id: @reader.id)
		  end
	  end
		@reader.books << @book
		if !params[:review].empty?
			@review = Review.create(reader: @reader, book: @book, content: params[:review],rating: params[:rating].to_i)
		end

		redirect "/books/#{@book.id}"
	end

	get '/books/:id' do
		redirect_if_not_logged_in
    @reader =current_reader
		@book= Book.find(params[:id])
		@categories= @book.categories_list.join(",")
		erb :"/books/show_book"
	end

	get '/books/:id/edit' do 
		redirect_if_not_logged_in
		@reader= current_reader
		@book= Book.find(params[:id])

		@reader_categories= @book.categories.where(reader_id: @reader.id).map{|c| c.name}.join(",")
		@all_categories=@book.categories.map{|c| c.name}.join(",")
		@review = Review.find_by(reader_id: @reader.id, book_id: @book.id)

		erb :"/books/edit_book"
	end

	post '/books/:id' do
		@reader= current_reader
		@book= Book.find(params[:id])
		@categories = params[:category].split(",").compact if !params[:category].empty?
		
		@categories.each do |c|
			@book.categories.find_or_create_by(name: c, reader_id: @reader.id)
	  end	

		if @reader.books.exists?(@book)
			@review = Review.find_or_create_by(reader_id: @reader.id, book_id: @book.id)
	    @review.update(content: params[:content], rating: params[:rating].to_i)
    else
    	@reader.books << @book
    	@review = Review.create(reader_id: @reader.id, book_id: @book.id)
	    @review.update(content: params[:content], rating: params[:rating].to_i)
    end

    redirect "/books/#{@book.id}"
	end


	

	delete '/books/:id/delete' do
		
		@reader =current_reader
		@book= Book.find(params[:id])
		@review = Review.find_by(reader_id: @reader.id, book_id: @book.id)
		redirect '/books' if !@reader.books.exists?(@book) #need error message
		
		
		@review.delete if @review
		@reader.books.delete(@book)
		@reader.save
		@book.save
		@book.delete if @book.readers.empty?
		redirect '/books'
				
	end	

end
