class BooksController < ApplicationController

	before do
		redirect_if_not_logged_in
	end

	get '/books' do
		@reader= Reader.find_by(id: session[:id])
		@reader_books =@reader.books
		@other_books = @reader.books_read_by_others
		erb :"/books/index"
	end

	get '/books/new' do
		if !params[:title].blank?
			@title= params[:title]
		else
			@title= nil
		end
		erb :'/books/create'
	end

# can use some refactoring here?
	post '/books' do
		@reader= current_reader
		if existing_book = Book.find_by(title: params[:title])
			if @reader.books.exists?(existing_book)
				flash[:notice] = "This book is already in your reading list"
			else
				flash[:notice] = "This book is being read by others"
			end
			redirect "/books/#{existing_book.id}/edit"
		else
			@book = @reader.books.build(title: params[:title])
			if @book.invalid? #cannot use @book.save here ?
				flash[:errors] = @book.errors.full_messages
				redirect '/books/new'
			else
				@book.save
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
	end



=begin
		if existing_book = Book.find_by(title: params[:title])
				if @reader.books.exists?(existing_book)
				flash[:notice] = "This book is already in your reading list"
			else
				flash[:notice] = "This book is being read by others"
			end
			redirect "/books/#{existing_book.id}/edit"
		else
			@book = @reader.books.build(title: params[:title])
			if @book.save
				flash[:errors] = book.errors.full_messages
				redirect '/books/new'
			else
				if !params[:category].blank?
					params[:category].split(",").each do |c|
				  	@book.categories.create(name: c)
				  end
			  end
				@reader.books << @book
				if !params[:review].blank?
					@review = Review.create(reader: @reader, book: @book, content: params[:review],rating: params[:rating].to_i)
				end
				redirect "/books/#{@book.id}"
			end
		end
	end
=end


	get '/books/:id' do
    @reader =current_reader
		@book= Book.find(params[:id])
		@categories= @book.categories_list
		erb :"/books/show"
	end

	get '/books/:id/edit' do
		@reader= current_reader
		@book= Book.find(params[:id])
		@review = Review.find_or_create_by(reader_id: @reader.id, book_id: @book.id)
		@reader_categories= @review.categories.map{|c| c.name}.join(",")
		@all_categories=@book.categories.map{|c| c.name}.join(",")

		erb :"/books/edit"
	end

	patch '/books/:id' do
		@reader= current_reader
		@book= Book.find(params[:id])
		@review = Review.find_by(reader_id: @reader.id, book_id: @book.id)
		if !params[:category].blank?
		  @categories = params[:category].split(",").compact.map(&:strip)
			@review.category_ids = @categories.map do |c|
				@review.categories.find_or_create_by(name: c).id
		  end
    end
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
