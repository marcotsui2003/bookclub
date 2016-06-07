#clear the database first
Reader.delete_all
ReaderBook.delete_all
Book.delete_all
BookCategory.delete_all
Category.delete_all
Review.delete_all




readers =[
					{username: "Mary",
						password: "xxx123456",
						password_confirmation: "xxx123456"},
					{username: "Peter",
						password:"yyy123456",
					password_confirmation: "yyy123456"},
					{username: "Helen",
						password: "zzz123456",
						password_confirmation: "zzz123456"},
					{username: "David",
						password: "123456789",
						password_confirmation: "123456789"}
					]

readers.each do |reader|
	Reader.create(reader)
end

books=["War and Peace","The Well-Grounded Rubyist","Effective JavaScript","The Rails 4 Way", "History of World War II"]
books.each do |book|
	Book.create(title: book)
end

categories= ['programming language', 'computer science', 'fiction', 'non-fiction', 'web development', 'literature', 'history' ]
categories.each do |category|
	Category.create(name: category)
end

a = Reader.find_by(username: "Mary")
a.books << [Book.find_by(title: "War and Peace"), Book.find_by(title: "History of World War II")]
a.save

b = Reader.find_by(username: "Peter")
b.books << [Book.find_by(title: "The Well-Grounded Rubyist")]
b.save

c = Reader.find_by(username: "Helen")
c.books << [Book.find_by(title: "The Well-Grounded Rubyist"), Book.find_by(title: "The Rails 4 Way")]
c.save

d = Reader.find_by(username: "David")
d.books << [Book.find_by(title: "The Well-Grounded Rubyist"), Book.find_by(title: "The Rails 4 Way"), Book.find_by(title: "Effective JavaScript" )]
d.save

e= Category.find_by(name: 'programming language')
f= Category.find_by(name: 'computer science')
g= Category.find_by(name: 'fiction')
h= Category.find_by(name: 'non-fiction')
i= Category.find_by(name: 'web development')
j= Category.find_by(name: 'literature')
k= Category.find_by(name: 'history')

e.books <<[Book.find_by(title: "The Well-Grounded Rubyist"), Book.find_by(title: "The Rails 4 Way"), Book.find_by(title: "Effective JavaScript" )]
f.books << [Book.find_by(title: "The Well-Grounded Rubyist"), Book.find_by(title: "The Rails 4 Way"), Book.find_by(title: "Effective JavaScript" )]
g.books << Book.find_by(title: "War and Peace")
h.books << [Book.find_by(title: "The Well-Grounded Rubyist"), Book.find_by(title: "The Rails 4 Way"), Book.find_by(title: "Effective JavaScript" ), Book.find_by(title: "History of World War II")]
i.books << [Book.find_by(title: "The Well-Grounded Rubyist"), Book.find_by(title: "The Rails 4 Way"), Book.find_by(title: "Effective JavaScript" )]
j.books << Book.find_by(title: "War and Peace")
k.books << Book.find_by(title: "History of World War II")


r1= Review.create(rating: 4,reader: a, book: Book.find_by(title: "The Well-Grounded Rubyist"), content:"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
r2= Review.create(rating: 1,reader: a, book: Book.find_by(title: "The Rails 4 Way"), content:"Great!")
r3= Review.create(rating: 2,reader: b, book: Book.find_by(title: "War and Peace"), content:"Master Piece")
r4= Review.create(rating: 3,reader: c, book: Book.find_by(title: "History of World War II"), content:"So-so.")
