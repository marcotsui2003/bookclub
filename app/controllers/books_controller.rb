class BooksController < ApplicationController

	before do
		redirect_if_not_logged_in
	end

	get '/books' do
		@reader= current_reader
		@reader_books = @reader.books
		@other_books = @reader.books_read_by_others
		erb :"/books/index"
	end

	get '/books/new' do
		@title= params[:title]
		erb :'/books/create'
	end

	post '/books' do
		# check if the book is already in the reader's reading list
		@reader= current_reader
		if existing_book = @reader.books.find_by(title: standardize_title(params[:title])) # There is a helper method and a model instance method
			flash[:notice] = "This book is already in your reading list"
			redirect "/books/#{existing_book.id}/edit"
		end

		@book = Book.find_or_initialize_by(title: standardize_title(params[:title]))
		if @book.invalid?
			flash[:errors] = @book.errors.full_messages
			redirect '/books/new'
		else
			@book.save
			@reader.books << @book
			@review = @book.reviews.find_by(reader_id: @reader.id)
			@review.update(content: params[:content], rating: params[:rating], categories: params[:categories])
			redirect "/books/#{@book.id}"
		end
	end


	get '/books/:id' do
    @reader =current_reader
		@book= Book.find(params[:id])
		@categories= @book.category_array
		erb :"/books/show"
	end

	get '/books/:id/edit' do
		@reader= current_reader
		@book= Book.find(params[:id])
		@review = Review.find_or_create_by(reader_id: @reader.id, book_id: @book.id)
		@reader_categories= @review.category_list
		@all_categories=@book.category_list
		erb :"/books/edit"
	end

	patch '/books/:id' do
		@reader= current_reader
		@book= Book.find(params[:id])
		@review = Review.find_or_create_by(reader_id: @reader.id, book_id: @book.id)
		@review.update(content: params[:content], rating: params[:rating], categories: params[:categories])
    # @reader.books << @book
    flash[:notice]= "Book successfully added/edited."
    redirect "/books/#{@book.id}"
	end

	delete '/books/:id/delete' do
		@reader =current_reader
		@book= Book.find(params[:id])
		@review = Review.find_by(reader_id: @reader.id, book_id: @book.id)
    if !@review
			flash[:errors] =["#{@book.title} is not on your reading list"]
		  redirect '/books'
		else
			@review.delete
			@reader.save
			@book.delete if @book.readers.blank?
			redirect '/books'
	  end
	end

end
