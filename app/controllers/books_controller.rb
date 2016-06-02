class BooksController < ApplicationController

	before do
		redirect_if_not_logged_in
	end

	get '/books' do
		#redirect_if_not_logged_in
		@reader= Reader.find_by(session[:id])
		@reader_books =@reader.books
		@other_books = @reader.books_read_by_others
		erb :"/books/index"
	end

	get '/books/new' do
		#redirect_if_not_logged_in
		if !params[:title].nil?
			@title= params[:title]
		else
			@title= nil
		end
		erb :'/books/create'
	end

	post '/books' do
		@reader= current_reader
		book = Book.new(title: params[:title])
		if book.invalid?
			flash[:errors] = book.errors.full_messages
			redirect '/books/new'
		elsif
      existing_book = Book.find_by(title: params[:title])
			if @reader.books.exists?(existing_book)
				flash[:notice] = "This book is already in your reading list"
			else
				flash[:notice] = "This book is being read by others"
			end
			redirect "/books/#{existing_book.id}/edit"
		else

=begin
if existing_book = Book.find_by(title: params[:title])
	if @reader.books.exists?(existing_book)
		flash[:notice] = "This book is already in your reading list"
	else
		flash[:notice] = "This book is being read by others"
	end
	redirect "/books/#{existing_book.id}/edit"
end
=end

=begin

		if !@book.valid?
 			flash[:errors] = @book.errors.full_messages
			redirect "/books/new"
		end



    book = @reader.books.find_by(title: params[:title])
		if book
			flash[:errors] = ["This book is already in your reading list."]
			redirect "/books/#{book.id}"
		end
=end

			@book = Book.create(title: params[:title])
			if !params[:category].blank?
				params[:category].split(",").each do |c|
			  	@book.categories.create(name: c, reader_id: @reader.id)
			  end
		  end
			@reader.books << @book
			if !params[:review].blank?
				@review = Review.create(reader: @reader, book: @book, content: params[:review],rating: params[:rating].to_i)
			end
			redirect "/books/#{@book.id}"
		end
	end


	get '/books/:id' do
		#redirect_if_not_logged_in
    @reader =current_reader
		@book= Book.find(params[:id])
		@categories= @book.categories_list
		erb :"/books/show"
	end

	get '/books/:id/edit' do
		#redirect_if_not_logged_in
		@reader= current_reader
		@book= Book.find(params[:id])

		@reader_categories= @book.categories.where(reader_id: @reader.id).map{|c| c.name}.join(",")
		@all_categories=@book.categories.map{|c| c.name}.join(",")
		@review = Review.find_by(reader_id: @reader.id, book_id: @book.id)

		erb :"/books/edit"
	end

	patch '/books/:id' do
		@reader= current_reader
		@book= Book.find(params[:id])

		if !params[:category].blank?
		  @categories = params[:category].split(",").compact

			@categories.each do |c|
				@book.categories.find_or_create_by(name: c, reader_id: @reader.id)
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

    redirect "/books/#{@book.id}"
	end




	delete '/books/:id/delete' do

		@reader =current_reader
		@book= Book.find(params[:id])
		@review = Review.find_by(reader_id: @reader.id, book_id: @book.id)
    if !@reader.books.exists?(@book)
			flash[:errors] =["#{@book.title} is not on your reading list"]
		  redirect '/books'
		end
		# can I condense the code below?
		@review.delete if @review
		@reader.books.delete(@book)
		@reader.save
		@book.save
		@book.delete if @book.readers.blank?
		redirect '/books'

	end

end
