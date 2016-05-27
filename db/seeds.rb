#clear the database first
Reader.delete_all
ReaderBook.delete_all
Book.delete_all
BookCategory.delete_all
Category.delete_all
Review.delete_all




readers =[
					{username: "A",
						password: "xxx123456"},
					{username: "B",
						password:"yyy123456"},
						{username: "C",
							password: "zzz123456"}
					]

readers.each do |reader|
	Reader.create(reader)
end

books=["D","E","F","G"]
books.each do |book|
	Book.create(title: book)
end

categories= ['romance', 'science', 'history']
categories.each do |category|
	Category.create(name: category)
end

a = Reader.find_by(username: "A")
a.books << [Book.find_by(title: "D"), Book.find_by(title: "E")]
a.save

b = Reader.find_by(username: "B")
b.books << [Book.find_by(title: "F")]
b.save

c = Reader.find_by(username: "C")
c.books << [Book.find_by(title: "F"), Book.find_by(title: "G")]
c.save

r= Category.find_by(name: 'romance')
s= Category.find_by(name: 'science')
h= Category.find_by(name: 'history')

r.books<<[Book.find_by(title: "D")]
r.save
s.books<<[Book.find_by(title: "E"), Book.find_by(title: "G")]
s.save
h.books<<[Book.find_by(title: "D"), Book.find_by(title: "F"),Book.find_by(title: "G")]
h.save

r1= Review.create(rating: 4,reader: Reader.find_by(username: "A"), book: Book.find_by(title: "D"), content:"Excellent!")
r2= Review.create(rating: 1,reader: Reader.find_by(username: "A"), book: Book.find_by(title: "E"), content:"Boring...")
r3= Review.create(rating: 2,reader: Reader.find_by(username: "B"), book: Book.find_by(title: "F"), content:"Ordinary.")
r4= Review.create(rating: 3,reader: Reader.find_by(username: "C"), book: Book.find_by(title: "F"), content:"So-so.")
