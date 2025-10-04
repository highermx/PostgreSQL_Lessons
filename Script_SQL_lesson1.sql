create table users.books(
	book_id serial primary key,
	title varchar(255) not null,
	author varchar(255) not null,
	published_year int check(published_year > 0),
	genre varchar(100)
);

create table users.readers(
	reader_id serial primary key,
	name varchar(100) not null,
	email varchar(255) unique not null,
	phone varchar(15) unique 
);

create table users.borrowed_books(
	id serial primary key,
	book_id int not null references users.books(book_id) on delete cascade,
	reader_id int not null references users.readers(reader_id) on delete cascade,
	borrow_date date not null,
	return_date date,
	status varchar(20) check (status in('borrowed','returned'))
);

create index idx_books_title on users.books(title);
create index idx_active_borrows on users.borrowed_books(status, return_date)
where status = 'borrowed';