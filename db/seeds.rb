#clear the database first
Reader.delete_all
Book.delete_all
ReviewCategory.delete_all
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



e= Category.create(name: 'programming language')
f= Category.create(name: 'computer science')
g= Category.create(name: 'fiction')
h= Category.create(name: 'non-fiction')
i= Category.create(name: 'web development')
j= Category.create(name: 'literature')
k= Category.create(name: 'history')

l= Book.create(title: 'War and Peace')
m= Book.create(title: 'The Well-Grounded Rubyist')
n= Book.create(title: 'Effective JavaScript')
o= Book.create(title: 'The Rails 4 Way')
p= Book.create(title: 'History of World War II')



a = Reader.find_by(username: "Mary")
a.books << [l, p]
r_a1 = a.reviews.find_by(book_id: l.id)
r_a2 = a.reviews.find_by(book_id: p.id)
r_a1.content = "excellent"
r_a1.categories <<  [g,j]
r_a2.content = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
r_a2.categories << [j,k]
r_a1.save
r_a2.save

b = Reader.find_by(username: "Peter")
b.books << m
r_b1 = b.reviews.find_by(book_id: m.id)
r_b1.content = "fantastic"
r_b1.save


c = Reader.find_by(username: "Helen")
c.books << [m,o]
r_c1 = c.reviews.find_by(book_id: m.id)
r_c2 = c.reviews.find_by(book_id: o.id)
r_c1.content = "solid!"
r_c1.categories << [e,i]
r_c1.save
r_c2.content = "Great!"
r_c2.categories << [e,i]
r_c2.save

d = Reader.find_by(username: "David")
d.books << [Book.find_by(title: "The Well-Grounded Rubyist"), Book.find_by(title: "The Rails 4 Way"), Book.find_by(title: "Effective JavaScript" )]
