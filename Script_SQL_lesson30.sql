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

INSERT INTO library.books (title, author, published_year, genre) 
VALUES 
('1984', 'Джордж Оруэлл', 1949, 'Антиутопия'),
('Мастер и Маргарита', 'Михаил Булгаков', 1966, 'Роман'),
('Гарри Поттер и философский камень', 'Дж.К. Роулинг', 1997, 'Фэнтези'),
('Преступление и наказание', 'Ф.М. Достоевский', 1866, 'Классика');

-- Читатели
INSERT INTO library.readers (name, email, phone) 
VALUES 
('Иван Петров', 'ivan@example.com', '+79161234567'),
('Мария Сидорова', 'maria@example.com', '+79031234567'),
('Алексей Иванов', 'alex@example.com', NULL);

-- Выдача книг
INSERT INTO library.borrowed_books (book_id, reader_id, borrow_date, status) 
VALUES 
(1, 1, '2025-09-01', 'borrowed'),
(2, 2, '2025-09-15', 'returned'),
(3, 3, '2025-10-05', 'borrowed');

UPDATE library.books 
SET published_year = 1967 
WHERE book_id = 2;

UPDATE library.borrowed_books 
SET return_date = CURRENT_DATE, status = 'returned' 
WHERE borrow_id = 1;

-- Удаление читателя с reader_id=3
DELETE FROM library.readers 
WHERE reader_id = 3;

-- Удаление записей о книге с book_id=2
DELETE FROM library.borrowed_books 
WHERE book_id = 2;

BEGIN;
-- Добавление новой книги
INSERT INTO library.books (title, author, published_year, genre) 
VALUES ('451° по Фаренгейту', 'Рэй Брэдбери', 1953, 'Фантастика');

-- Создание записи о выдаче
INSERT INTO library.borrowed_books (book_id, reader_id, borrow_date, status) 
VALUES (4, 1, CURRENT_DATE, 'borrowed');

ROLLBACK;

BEGIN;
-- Повтор операций
INSERT INTO library.books (title, author, published_year, genre) 
VALUES ('451° по Фаренгейту', 'Рэй Брэдбери', 1953, 'Фантастика');

INSERT INTO library.borrowed_books (book_id, reader_id, borrow_date, status) 
VALUES (4, 1, CURRENT_DATE, 'borrowed');

COMMIT;

SELECT 
    b.title,
    b.author,
    bb.reader_id,
    bb.borrow_date
FROM library.books b
INNER JOIN library.borrowed_books bb 
    ON b.book_id = bb.book_id
WHERE bb.status = 'borrowed';

SELECT 
    reader_id,
    COUNT(*) AS total_borrowed
FROM library.borrowed_books
GROUP BY reader_id;

SELECT 
    reader_id,
    COUNT(*) AS total_borrowed
FROM library.borrowed_books
GROUP BY reader_id
HAVING COUNT(*) > 1;

SELECT 
    b.title,
    b.genre,
    bb.borrow_date,
    bb.return_date
FROM library.books b
LEFT JOIN library.borrowed_books bb 
    ON b.book_id = bb.book_id
WHERE b.genre = 'Фэнтези';

-- Проверка таблиц
SELECT * FROM library.books;
SELECT * FROM library.readers;
SELECT * FROM library.borrowed_books;