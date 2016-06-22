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
		if existing_book = @reader.books.find_by(title: params[:title].strip.titlecase)
			flash[:notice] = "This book is already in your reading list"
			redirect "/books/#{existing_book.id}/edit"
		end

		@book = Book.find_or_initialize_by(title: params[:title].strip.titlecase)
		if @book.invalid? #cannot use @book.save here ?
			flash[:errors] = @book.errors.full_messages
			redirect '/books/new'
		else
			@book.save
			@reader.books << @book
			@review = @book.reviews.find_by(reader_id: @reader.id)
			if !params[:category].blank?
				params[:category].split(",").each do |c|
			  	@review.categories.find_or_create_by(name: c)
			  end
		  end
			if !params[:review].blank?
				@review.content = params[:review]
				@review.rating = params[:rating].to_i
				@review.save
			end
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
		@review = Review.find_by(reader_id: @reader.id, book_id: @book.id)
    #this can definitely moved to the model
		if !params[:category].blank?
		  @categories = params[:category].split(",").compact.map(&:strip)
			@review.category_ids = @categories.map do |c|
				Category.find_or_create_by(name: c).id
		  end
    end
		#checked nested attributes....
		if @reader.books.exists?(@book)
			@review = Review.find_or_create_by(reader_id: @reader.id, book_id: @book.id)
	    @review.update(content: params[:content], rating: params[:rating])
    else
    	@reader.books << @book
    	@review = Review.create(reader_id: @reader.id, book_id: @book.id)
	    @review.update(content: params[:content], rating: params[:rating])
    end
    flash[:notice]= "Book successfully edited."
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
			# can I condense the code below?
			@review.delete
			#@reader.books.delete(@book)
			@reader.save
			#@book.save
			@book.delete if @book.readers.blank?
			redirect '/books'
	  end
	end

end
