--TABLES
DROP TABLE IF EXISTS Account CASCADE;
DROP TABLE IF EXISTS Book CASCADE;
DROP TABLE IF EXISTS Individual CASCADE;
DROP TABLE IF EXISTS Bookstore;
DROP TABLE IF EXISTS Comic_book;
DROP TABLE IF EXISTS Purchase CASCADE;
DROP TABLE IF EXISTS Listing CASCADE;
DROP TABLE IF EXISTS Return;
DROP TABLE IF EXISTS Trade;
DROP TABLE IF EXISTS Message;
DROP TABLE IF EXISTS Author CASCADE;
DROP TABLE IF EXISTS Artist CASCADE;
DROP TABLE IF EXISTS Book_author;
DROP TABLE IF EXISTS Comic_book_artist;
DROP TABLE IF EXISTS Address;
DROP TABLE IF EXISTS Payment_Option;
DROP TABLE IF EXISTS List_price_change;

CREATE TABLE Address (
    address_id integer NOT NULL,
    street varchar(50) NOT NULL,
    city varchar(25) NOT NULL,
    state varchar(2) NOT NULL,
    zip_code integer NOT NULL,
    PRIMARY KEY (address_id)
);

CREATE TABLE Account (
    account_id integer NOT NULL,
    username varchar(50) NOT NULL,
    email varchar(64) NOT NULL,
    account_type varchar(10) NOT NULL,
    address_id integer NOT NULL,
    PRIMARY KEY (account_id),
    FOREIGN KEY (address_id) REFERENCES Address
);

CREATE TABLE Individual (
    account_id integer NOT NULL,
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    PRIMARY KEY (account_id),
    FOREIGN KEY (account_id) REFERENCES Account
);

CREATE TABLE Bookstore (
    account_id integer NOT NULL,
    store_name varchar(100) NOT NULL,
    PRIMARY KEY (account_id),
    FOREIGN KEY (account_id) REFERENCES Account
);

CREATE TABLE Book (
    book_id integer NOT NULL,
    isbn bigint,
    title varchar(200) NOT NULL,
    edition varchar(100) NOT NULL,
    publication_year date NOT NULL,
    image bytea,
    condition text NOT NULL,
    book_type varchar(20),
    PRIMARY KEY (book_id)
);

CREATE TABLE Author (
    author_id INTEGER NOT NULL,
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    PRIMARY KEY( author_id)
);

CREATE TABLE Book_author (
    book_id integer NOT NULL,
    author_id integer NOT NULL,
    FOREIGN KEY (book_id) REFERENCES Book,
    FOREIGN KEY (author_id) REFERENCES Author,
    PRIMARY KEY (book_id, author_id)
);

CREATE TABLE Comic_book (
    book_id integer NOT NULL,
    issue_no integer NOT NULL,
    PRIMARY KEY (book_id),
    FOREIGN KEY (book_id) REFERENCES Book
);

CREATE TABLE Artist (
    artist_id INTEGER NOT NULL,
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    PRIMARY KEY (artist_id)
);

CREATE TABLE Comic_book_artist (
    book_id integer NOT NULL,
    artist_id integer NOT NULL,
    FOREIGN KEY (book_id) REFERENCES Comic_book,
    FOREIGN KEY (artist_id) REFERENCES Artist,
    PRIMARY KEY (book_id, artist_id)
);

CREATE TABLE Payment_option (
    payment_option_id integer NOT NULL,
    type_name varchar(20) NOT NULL,
    PRIMARY KEY (payment_option_id)
);

CREATE TABLE Purchase (
    purchase_id integer NOT NULL,
    buyer_id integer NOT NULL,
    purchase_price money NOT NULL,
    payment_option_id integer NOT NULL,
    billing_address_id integer NOT NULL,
    shipping_address_id integer NOT NULL,
    purchase_time timestamp NOT NULL,
    PRIMARY KEY (purchase_id),
    FOREIGN KEY (buyer_id) REFERENCES Account(account_id),
    FOREIGN KEY (payment_option_id) REFERENCES Payment_Option,
    FOREIGN KEY (billing_address_id) REFERENCES Address(address_id),
    FOREIGN KEY (shipping_address_id) REFERENCES Address(address_id)
);

CREATE TABLE Listing (
    listing_id integer NOT NULL,
    account_id integer NOT NULL,
    book_id integer NOT NULL,
    purchase_id integer,
    list_price money NOT NULL,
    PRIMARY KEY (listing_id),
    FOREIGN KEY (account_id) REFERENCES Account,
    FOREIGN KEY (book_id) REFERENCES Book,
    FOREIGN KEY (purchase_id) REFERENCES Purchase
);

CREATE TABLE Return (
    return_id integer NOT NULL,
    purchase_id integer NOT NULL,
    received_date date,
    completed_date date,
    PRIMARY KEY (return_id),
    FOREIGN KEY (purchase_id) REFERENCES Purchase
);

CREATE TABLE Trade (
    trade_id integer NOT NULL,
    trader_id integer NOT NULL,
    tradee_id integer NOT NULL,
    offer_listing_id integer NOT NULL,
    desired_listing_id integer NOT NULL,
    offered_time timestamp NOT NULL,
    accepted_time timestamp,
    PRIMARY KEY (trade_id),
    FOREIGN KEY (trader_id) REFERENCES Individual (account_id),
    FOREIGN KEY (tradee_id) REFERENCES Individual (account_id),
    FOREIGN KEY (offer_listing_id) REFERENCES Listing (listing_id),
    FOREIGN KEY (desired_listing_id) REFERENCES Listing (listing_id)
);

CREATE TABLE Message (
    message_id integer NOT NULL,
    sender_id integer NOT NULL,
    recipient_id integer NOT NULL,
    content text NOT NULL,
    subject varchar(200) NOT NULL,
    send_time timestamp NOT NULL,
    PRIMARY KEY (message_id),
    FOREIGN KEY (sender_id) REFERENCES Individual (account_id),
    FOREIGN KEY (recipient_id) REFERENCES Individual (account_id)
);

CREATE TABLE List_price_change (
    list_price_change_id integer NOT NULL,
    listing_id integer NOT NULL,
    old_list_price money NOT NULL,
    new_list_price money NOT NULL,
    change_time timestamp NOT NULL,
    PRIMARY KEY (list_price_change_id),
    FOREIGN KEY (listing_id) REFERENCES Listing
);

--SEQUENCES
DROP SEQUENCE IF EXISTS account_seq;
DROP SEQUENCE IF EXISTS book_seq;
DROP SEQUENCE IF EXISTS purchase_seq;
DROP SEQUENCE IF EXISTS listing_seq;
DROP SEQUENCE IF EXISTS return_seq;
DROP SEQUENCE IF EXISTS trade_seq;
DROP SEQUENCE IF EXISTS message_seq;
DROP SEQUENCE IF EXISTS author_seq;
DROP SEQUENCE IF EXISTS artist_seq;
DROP SEQUENCE IF EXISTS address_seq;
DROP SEQUENCE IF EXISTS payment_option_seq;
DROP SEQUENCE IF EXISTS list_price_change_seq;

CREATE SEQUENCE account_seq START WITH 1;
CREATE SEQUENCE book_seq START WITH 1;
CREATE SEQUENCE purchase_seq START WITH 1;
CREATE SEQUENCE listing_seq START WITH 1;
CREATE SEQUENCE return_seq START WITH 1;
CREATE SEQUENCE trade_seq START WITH 1;
CREATE SEQUENCE message_seq START WITH 1;
CREATE SEQUENCE author_seq START WITH 1;
CREATE SEQUENCE artist_seq START WITH 1;
CREATE SEQUENCE address_seq START WITH 1;
CREATE SEQUENCE payment_option_seq START WITH 1;
CREATE SEQUENCE list_price_change_seq START WITH 1;

--INDEXES

--Foreign keys
CREATE INDEX Account_address_id_idx
ON Account(address_id);

CREATE INDEX Message_sender_id_idx
ON Message(sender_id);

CREATE INDEX Message_recipient_id_idx
ON Message(recipient_id);

CREATE INDEX Trade_trader_id_idx
ON Trade(trader_id);

CREATE INDEX Trade_tradee_id_idx
ON Trade(tradee_id);

CREATE INDEX Trade_offer_listing_id_idx
ON Trade(offer_listing_id);

CREATE INDEX Trade_desired_listing_id_idx
ON Trade(desired_listing_id);

CREATE INDEX Listing_account_id_idx
ON Listing(account_id);

CREATE INDEX Listing_book_id_idx
ON Listing(book_id);

CREATE INDEX Purchase_buyer_id_idx
ON Purchase(buyer_id);

CREATE INDEX Purchase_payment_option_id_idx
ON Purchase(payment_option_id);

CREATE INDEX Purchase_billing_address_id_idx
ON Purchase(billing_address_id);

CREATE INDEX Purchase_shipping_address_id_idx
ON Purchase(shipping_address_id);

CREATE UNIQUE INDEX Return_purchase_id_idx
ON Return(purchase_id);

CREATE INDEX Purchase_purchase_price_idx
ON Purchase(purchase_price);

CREATE INDEX Purchase_purchase_time_idx
ON Purchase(purchase_time);

CREATE UNIQUE INDEX Account_username_idx
ON Account(username);

CREATE INDEX List_price_change_listing_id_idx
ON List_price_change(listing_id);

--STORED PROCEDURES

-- Add a new user
CREATE OR REPLACE PROCEDURE Add_new_user(street_arg IN varchar(50), city_arg IN varchar(25), state_arg IN varchar(2),
    zip_code_arg IN integer, username_arg IN varchar(50), email_arg IN varchar(64), account_type_arg IN varchar(10),
    first_name_arg IN varchar(50) = '', last_name_arg IN varchar(50) = '', store_name_arg IN varchar(100) = '')
AS
$proc$
DECLARE address_id_value integer;
BEGIN
	
	IF EXISTS (SELECT address_id FROM Address WHERE street = street_arg AND city = city_arg 
			   AND state = state_arg AND zip_code = zip_code_arg) THEN
	    address_id_value := (SELECT address_id FROM Address WHERE street = street_arg AND city = city_arg
			AND state = state_arg AND zip_code = zip_code_arg);
	ELSE
		address_id_value := nextval('address_seq');
		INSERT INTO Address(address_id, street, city, state, zip_code)
    	VALUES(address_id_value, street_arg, city_arg, state_arg, zip_code_arg);
	END IF;
	
    INSERT INTO Account(account_id, username, email, account_type, address_id)
    VALUES(nextval('account_seq'), username_arg, email_arg, account_type_arg, address_id_value);

    IF account_type_arg = 'individual' THEN
            INSERT INTO Individual(account_id, first_name, last_name)
            VALUES(currval('account_seq'), first_name_arg, last_name_arg);
    ELSIF account_type_arg = 'bookstore' THEN
            INSERT INTO Bookstore(account_id, store_name)
            VALUES(currval('account_seq'), store_name_arg);
    ELSE
        ROLLBACK;
	END IF;
END;
$proc$ LANGUAGE plpgsql;

-- Add a new chat message
CREATE OR REPLACE PROCEDURE Add_new_message(sender_username_arg IN varchar, recipient_username_arg IN varchar, 
										    content_arg IN text, subject_arg IN varchar(200))
AS
$proc$
BEGIN
    INSERT INTO Message(message_id, sender_id, recipient_id, content, subject, send_time)
    VALUES(nextval('message_seq'), (SELECT account_id FROM Account WHERE username = sender_username_arg), 
		   (SELECT account_id FROM Account WHERE username = recipient_username_arg), 
		   content_arg, subject_arg, clock_timestamp());
END;
$proc$ LANGUAGE plpgsql;

-- Add a new book listing
CREATE OR REPLACE PROCEDURE Add_new_book_listing(title_arg IN varchar, edition_arg varchar, condition_arg in text,
    publication_year_arg IN date, username_arg IN varchar, list_price_arg IN money,
	isbn_arg IN bigint = NULL, image_arg IN bytea = NULL)
AS
$proc$
BEGIN	
    INSERT INTO Book (book_id, isbn, title, edition, publication_year, image, condition)
    VALUES(nextval('book_seq'), isbn_arg, title_arg, edition_arg, publication_year_arg, image_arg, condition_arg);

    INSERT INTO Listing (listing_id, account_id, book_id, list_price)
    VALUES(nextval('listing_seq'), (SELECT account_id FROM Account WHERE username = username_arg), 
		   currval('book_seq'), list_price_arg);
		
END;
$proc$ LANGUAGE plpgsql;

-- Add a new comic book listing
CREATE OR REPLACE PROCEDURE Add_new_comic_book_listing(title_arg IN varchar, edition_arg varchar, condition_arg in text,
    publication_year_arg IN date, username_arg IN varchar, list_price_arg IN money, issue_no_arg IN integer,
	isbn_arg IN bigint = NULL, image_arg IN bytea = NULL)
AS
$proc$
BEGIN	
    INSERT INTO Book (book_id, isbn, title, edition, publication_year, image, condition, book_type)
    VALUES(nextval('book_seq'), isbn_arg, title_arg, edition_arg, publication_year_arg, image_arg, 
		   condition_arg, 'comic book');

    INSERT INTO Listing (listing_id, account_id, book_id, list_price)
    VALUES(nextval('listing_seq'), (SELECT account_id FROM Account WHERE username = username_arg), 
		   currval('book_seq'), list_price_arg);
	
	INSERT INTO Comic_book (book_id, issue_no)
	VALUES(currval('book_seq'), issue_no_arg);
		
END;
$proc$ LANGUAGE plpgsql;

-- Add new Purchase
-- The assignemnt limit on not being able to manually enter foreign keys is problemtic here. For address I would need to enter all address fields
-- for 2 addresses, as well as all book fields to match the book to the correct ID. Unfortunately, I just took a shortcut and used the same
-- account address for both options, and matched only on book title, since time-wise I did not have the badnwidth to add dozens of parameters to a stored
-- procedure and then eneter them for the multiple purchases. 
CREATE OR REPLACE PROCEDURE Add_new_purchase(username_arg IN varchar, purchase_price_arg IN money, 
											 payment_option_arg IN varchar, title_arg IN varchar
											)
AS
$proc$
DECLARE account_id_value INT;
DECLARE address_id_value INT;
DECLARE listing_id_value INT;
DECLARE payment_option_id_value INT;
BEGIN	
	account_id_value := (SELECT account_id FROM Account WHERE username = username_arg);
	address_id_value := (SELECT ad.address_id 
					    FROM Address ad
						JOIN Account ac ON ad.address_id = ac.address_id
						WHERE ac.account_id = account_id_value);
	listing_id_value := (SELECT l.listing_id
						FROM Listing l
						JOIN Book b ON b.book_id = l.book_id
						WHERE b.title = title_arg);
	payment_option_id_value := (SELECT payment_option_id 
								FROM Payment_option 
								WHERE type_name = payment_option_arg);
	
    INSERT INTO Purchase (purchase_id, buyer_id, purchase_price, payment_option_id, billing_address_id,
						 shipping_address_id, purchase_time)
	VALUES(nextval('purchase_seq'), account_id_value, purchase_price_arg, payment_option_id_value, 
		   address_id_value, address_id_value, clock_timestamp());

    UPDATE Listing
	SET purchase_id = currval('purchase_seq')
	WHERE listing_id = listing_id_value;
		
END;
$proc$ LANGUAGE plpgsql;

-- Add new return
-- The purchase timestamp and user were the only unique values to use to grab the purchase ID for this. 
CREATE OR REPLACE PROCEDURE Add_new_return(username_arg IN varchar, purchase_time_arg IN timestamp)
AS
$proc$
DECLARE account_id_value INT;
DECLARE purchase_id_value INT;
BEGIN	
	account_id_value := (SELECT account_id FROM Account WHERE username = username_arg);
	purchase_id_value := (SELECT purchase_id
						 FROM Purchase
						 WHERE buyer_id = account_id_value AND purchase_time = purchase_time_arg);
	
    INSERT INTO Return (return_id, purchase_id)
	VALUES(nextval('return_seq'), purchase_id_value);
		
END;
$proc$ LANGUAGE plpgsql;

-- Add new trade
-- This ran into the same issue where I needed to take a shortcut on the book title, since trying to match on all the book fields
-- was making a super long parameter list.
CREATE OR REPLACE PROCEDURE Add_new_trade(trader_username_arg IN varchar, tradee_username_arg IN varchar, 
											 offer_title_arg IN varchar, desired_title_arg IN varchar
											)
AS
$proc$
DECLARE trader_id_value INT;
DECLARE tradee_id_value INT;
DECLARE offer_id_value INT;
DECLARE desired_id_value INT;
BEGIN	
	trader_id_value := (SELECT account_id FROM Account WHERE username = trader_username_arg);
	tradee_id_value := (SELECT account_id FROM Account WHERE username = tradee_username_arg);
	offer_id_value := (SELECT l.listing_id
						FROM Listing l
						JOIN Book b ON b.book_id = l.book_id
						WHERE b.title = offer_title_arg);
	desired_id_value := (SELECT l.listing_id
						FROM Listing l
						JOIN Book b ON b.book_id = l.book_id
						WHERE b.title = desired_title_arg);
	
    INSERT INTO Trade (trade_id, trader_id, tradee_id, offer_listing_id, desired_listing_id, offered_time)
	VALUES(nextval('trade_seq'), trader_id_value, tradee_id_value, offer_id_value, desired_id_value, 
		   clock_timestamp());
		
END;
$proc$ LANGUAGE plpgsql;

--INSERTS

--Individuals
START TRANSACTION;
DO
$$BEGIN
CALL Add_new_user('123 Memory Lane', 'Boston', 'MA', '12345', 'TJ1985', 'tjones@coldmail.com', 'individual',
    'Tom', 'Jones');
CALL Add_new_user('125 Future Avenue', 'Shreveport', 'LA', '12346', 'fharp5', 'fredh@hmail.com', 'individual',
    'Fred', 'Harper');
CALL Add_new_user('1600 Pennsylvania Avenue', 'Washington', 'DC', '98765', 'NanTheMan', 'rnegan@wh.gov', 'individual',
    'Rancy', 'Negan');
CALL Add_new_user('78 Happy Blvd', 'Portland', 'OR', '44444', 'DorisH34', 'dhornby@yaboo.com', 'individual',
    'Doris', 'Hornby');
CALL Add_new_user('66 Nowhere Road', 'Franklin', 'TN', '12349', 'patpat56', 'pattersonp@coldmail.com', 'individual',
    'Pat', 'Patterson');
CALL Add_new_user('1290 Revolution Road', 'Salem', 'MA', '66666', 'tinyTim', 'tthomas@hmail.com', 'individual',
	'Tim', 'Thomas');
END$$;
COMMIT;

--Bookstores
START TRANSACTION;
DO
$$BEGIN
CALL Add_new_user('78 Main Street', 'Boston', 'MA', '12345', 'cornerShop', 'info@theCornerBookshop.com', 'bookstore',
    '', '', 'The Corner Bookshop');
CALL Add_new_user('12 Sycamore Street', 'New York', 'NY', '14345', 'barne&nobles', 'info@barneandnobles.com', 'bookstore',
    '', '', 'Barne & Nobles');
CALL Add_new_user('55 Wellington Street', 'Philadelphia', 'PA', '9999', 'TRU', 'info@tomesrus.com', 'bookstore',
    '', '', 'Tomes R Us');
CALL Add_new_user('99 Left Avenue', 'Austin', 'TX', '12365', 'pjtaffington', 'info@pjs.com', 'bookstore',
    '', '', 'PJ Taffingtons');
CALL Add_new_user('11 Right Street', 'Salme', 'MA', '12245', 'bbooks', 'info@barnyardbooks.com', 'bookstore',
    '', '', 'Barnyard Books');
END$$;
COMMIT;

-- Listing: Books and authors
START TRANSACTION;
DO
$$BEGIN
CALL Add_new_book_listing('Database Systems: Design, Implementation, & Management 13th Edition', '13th Edition', 
						  'Excellent condition', '2020-01-01', 'barne&nobles', 
						  CAST(165.00 as money), 9781337627900);
INSERT INTO Author (author_id, first_name, last_name)
VALUES(nextval('author_seq'), 'Carlos', 'Coronel');
INSERT INTO Book_author (book_id, author_id)
VALUES(currval('book_seq'), currval('author_seq'));
INSERT INTO Author (author_id, first_name, last_name)
VALUES(nextval('author_seq'), 'Steven', 'Morris');
INSERT INTO Book_author (book_id, author_id)
VALUES(currval('book_seq'), currval('author_seq'));

CALL Add_new_book_listing('A Tale of Two Cities', '1st Edition', 
						  'Very worn, but still a 1st edition nonetheless', '1850-01-01', 'cornerShop', 
						  CAST(4500.00 as money));
INSERT INTO Author (author_id, first_name, last_name)
VALUES(nextval('author_seq'), 'Charles', 'Dickens');
INSERT INTO Book_author (book_id, author_id)
VALUES(currval('book_seq'), currval('author_seq'));

CALL Add_new_book_listing('The Odyssey', '1st Edition', 
						  'Barely legible parchment, but it is a classic!', '650-01-01 BC', 'TJ1985', 
						  CAST(1000000.00 as money));
INSERT INTO Author (author_id, first_name, last_name)
VALUES(nextval('author_seq'), 'Homer', 'None');
INSERT INTO Book_author (book_id, author_id)
VALUES(currval('book_seq'), currval('author_seq'));

CALL Add_new_book_listing('Pride & Prejudice', '13rd Edition', 
						  'Like New condition. Never been read!', '1880-01-01', 'NanTheMan', 
						  CAST(670.00 as money));
INSERT INTO Author (author_id, first_name, last_name)
VALUES(nextval('author_seq'), 'Jane', 'Austen');
INSERT INTO Book_author (book_id, author_id)
VALUES(currval('book_seq'), currval('author_seq'));

CALL Add_new_book_listing('15 Habits to Make You Rich Now', '1st Edition', 
						  'Like new condition', '2012-01-01', 'DorisH34', 
						  CAST(17.00 as money), 8781457627900);
INSERT INTO Author (author_id, first_name, last_name)
VALUES(nextval('author_seq'), 'Timothy', 'Williams');
INSERT INTO Book_author (book_id, author_id)
VALUES(currval('book_seq'), currval('author_seq'));

CALL Add_new_book_listing('Just Another Book Title', '3rd Edition', 
						  'Awful condition', '2008-01-01', 'TJ1985', 
						  CAST(8.00 as money), 8781347627900);
INSERT INTO Author (author_id, first_name, last_name)
VALUES(nextval('author_seq'), 'Jan', 'Janssen');
INSERT INTO Book_author (book_id, author_id)
VALUES(currval('book_seq'), currval('author_seq'));

CALL Add_new_book_listing('A Very Old Book', '5th Edition', 
						  'Still got it', '1987-01-01', 'fharp5', 
						  CAST(78.00 as money), 8781318627900);
INSERT INTO Author (author_id, first_name, last_name)
VALUES(nextval('author_seq'), 'Tom', 'Wellington');
INSERT INTO Book_author (book_id, author_id)
VALUES(currval('book_seq'), currval('author_seq'));

CALL Add_new_book_listing('Travelhood of the Sistering Pants', '1st Edition', 
						  'Brand New Condition', '1997-01-01', 'patpat56', 
						  CAST(56.00 as money), 8786718627900);
INSERT INTO Author (author_id, first_name, last_name)
VALUES(nextval('author_seq'), 'Ida', 'Morrisey');
INSERT INTO Book_author (book_id, author_id)
VALUES(currval('book_seq'), currval('author_seq'));

CALL Add_new_book_listing('The Audacity of Despair', '1st Edition', 
						  'Light wear and tear', '2018-01-01', 'bbooks', 
						  CAST(38.00 as money), 0186718627900);
INSERT INTO Author (author_id, first_name, last_name)
VALUES(nextval('author_seq'), 'Tarik', 'OHara');
INSERT INTO Book_author (book_id, author_id)
VALUES(currval('book_seq'), currval('author_seq'));

CALL Add_new_book_listing('Fun Times', '2nd reprinting', 
						  'Light wear and tear', '1962-01-01', 'TRU', 
						  CAST(188.00 as money), 1286718627900);
INSERT INTO Author (author_id, first_name, last_name)
VALUES(nextval('author_seq'), 'William', 'Williamson');
INSERT INTO Book_author (book_id, author_id)
VALUES(currval('book_seq'), currval('author_seq'));

CALL Add_new_book_listing('Sad Times', '1st Edition', 
						  'Torn front cover', '1935-01-01', 'TRU', 
						  CAST(66.00 as money));
INSERT INTO Author (author_id, first_name, last_name)
VALUES(nextval('author_seq'), 'Tommy', 'Gunn');
INSERT INTO Book_author (book_id, author_id)
VALUES(currval('book_seq'), currval('author_seq'));

CALL Add_new_book_listing('Great Working Title', '2nd Edition', 
						  'Mint Condition', '1929-01-01', 'fharp5', 
						  CAST(450.00 as money));
INSERT INTO Author (author_id, first_name, last_name)
VALUES(nextval('author_seq'), 'Jeremy', 'Piven');
INSERT INTO Book_author (book_id, author_id)
VALUES(currval('book_seq'), currval('author_seq'));

CALL Add_new_book_listing('What are we doing here?', '1st Edition', 
						  'Mold all over the thing', '1789-01-01', 'DorisH34', 
						  CAST(98.00 as money));
INSERT INTO Book_author (book_id, author_id)
VALUES(currval('book_seq'), 3);

CALL Add_new_book_listing('Yet another book', '1st Edition', 
						  'Wonderful amazing', '1996-01-01', 'TRU', 
						  CAST(116.00 as money));
INSERT INTO Author (author_id, first_name, last_name)
VALUES(nextval('author_seq'), 'James', 'Laremy');
INSERT INTO Book_author (book_id, author_id)
VALUES(currval('book_seq'), currval('author_seq'));
END$$;
COMMIT;

-- Listing: Comic books, authors, and artists
START TRANSACTION;
DO
$$BEGIN
CALL Add_new_comic_book_listing('Amazing Spider-Man', 'Reprint', 'Excellent condition', '1995-01-01', 'TJ1985', 
						  CAST(78.00 as money), 1, 123456789);
INSERT INTO Author (author_id, first_name, last_name)
VALUES(nextval('author_seq'), 'Stan', 'Lee');
INSERT INTO Book_author (book_id, author_id)
VALUES(currval('book_seq'), currval('author_seq'));
INSERT INTO Artist (artist_id, first_name, last_name)
VALUES(nextval('artist_seq'), 'Jack', 'Kirby');
INSERT INTO Comic_book_artist (book_id, artist_id)
VALUES(currval('book_seq'), currval('artist_seq'));

CALL Add_new_comic_book_listing('Astonishing X-Men', 'Original Printing', 'Light wear and tear', '2002-01-01', 'fharp5', 
						  CAST(34.00 as money), 7, 123456766);
INSERT INTO Author (author_id, first_name, last_name)
VALUES(nextval('author_seq'), 'Joss', 'Whedon');
INSERT INTO Book_author (book_id, author_id)
VALUES(currval('book_seq'), currval('author_seq'));
INSERT INTO Artist (artist_id, first_name, last_name)
VALUES(nextval('artist_seq'), 'John', 'Cassaday');
INSERT INTO Comic_book_artist (book_id, artist_id)
VALUES(currval('book_seq'), currval('artist_seq'));

CALL Add_new_comic_book_listing('Superman', 'Original Printing', 'Excellent condition', '1945-01-01', 'patpat56', 
						  CAST(123.00 as money), 23, 123452389);
INSERT INTO Author (author_id, first_name, last_name)
VALUES(nextval('author_seq'), 'Jerry', 'Siegel');
INSERT INTO Book_author (book_id, author_id)
VALUES(currval('book_seq'), currval('author_seq'));
INSERT INTO Artist (artist_id, first_name, last_name)
VALUES(nextval('artist_seq'), 'Joe', 'Shuster');
INSERT INTO Comic_book_artist (book_id, artist_id)
VALUES(currval('book_seq'), currval('artist_seq'));

CALL Add_new_comic_book_listing('Batman', 'Reprint', 'Mint condition', '1943-01-01', 'pjtaffington', 
						  CAST(250.00 as money), 1, 123766789);
INSERT INTO Author (author_id, first_name, last_name)
VALUES(nextval('author_seq'), 'Bob', 'Kane');
INSERT INTO Book_author (book_id, author_id)
VALUES(currval('book_seq'), currval('author_seq'));
INSERT INTO Artist (artist_id, first_name, last_name)
VALUES(nextval('artist_seq'), 'Bill', 'Finger');
INSERT INTO Comic_book_artist (book_id, artist_id)
VALUES(currval('book_seq'), currval('artist_seq'));

CALL Add_new_comic_book_listing('Avengers Forever', 'Original Printing', 
								'Last page has been torn, otherwise great condition', 
								'1998-01-01', 'patpat56', CAST(78.00 as money), 8, 178456789);
INSERT INTO Author (author_id, first_name, last_name)
VALUES(nextval('author_seq'), 'Thomas', 'Jefferson');
INSERT INTO Book_author (book_id, author_id)
VALUES(currval('book_seq'), currval('author_seq'));
INSERT INTO Artist (artist_id, first_name, last_name)
VALUES(nextval('artist_seq'), 'James', 'Madison');
INSERT INTO Comic_book_artist (book_id, artist_id)
VALUES(currval('book_seq'), currval('artist_seq'));

CALL Add_new_comic_book_listing('The Mighty Thor', 'Original Printing', 
								'Last page has been torn, otherwise great condition', 
								'1967-01-01', 'TRU', CAST(800.00 as money), 1);
INSERT INTO Author (author_id, first_name, last_name)
VALUES(nextval('author_seq'), 'Jack', 'Kirby');
INSERT INTO Book_author (book_id, author_id)
VALUES(currval('book_seq'), currval('author_seq'));
INSERT INTO Artist (artist_id, first_name, last_name)
VALUES(nextval('artist_seq'), 'Steve', 'Ditko');
INSERT INTO Comic_book_artist (book_id, artist_id)
VALUES(currval('book_seq'), currval('artist_seq'));

CALL Add_new_comic_book_listing('Wonder Woman Annual', 'Original Printing', 
								'Mint Condition', 
								'1978-01-01', 'patpat56', CAST(900.00 as money), 1);
INSERT INTO Author (author_id, first_name, last_name)
VALUES(nextval('author_seq'), 'Rachel', 'Murrow');
INSERT INTO Book_author (book_id, author_id)
VALUES(currval('book_seq'), currval('author_seq'));
INSERT INTO Artist (artist_id, first_name, last_name)
VALUES(nextval('artist_seq'), 'Melanie', 'Wilson');
INSERT INTO Comic_book_artist (book_id, artist_id)
VALUES(currval('book_seq'), currval('artist_seq'));

CALL Add_new_comic_book_listing('Green Lantern', 'Original Printing', 
								'Mint Condition', 
								'1924-01-01', 'DorisH34', CAST(375.00 as money), 14);
INSERT INTO Author (author_id, first_name, last_name)
VALUES(nextval('author_seq'), 'John', 'Green');
INSERT INTO Book_author (book_id, author_id)
VALUES(currval('book_seq'), currval('author_seq'));
INSERT INTO Artist (artist_id, first_name, last_name)
VALUES(nextval('artist_seq'), 'Artie', 'Johnson');
INSERT INTO Comic_book_artist (book_id, artist_id)
VALUES(currval('book_seq'), currval('artist_seq'));
END$$;
COMMIT;

-- Purchases and Payment options
START TRANSACTION;
DO
$$BEGIN
INSERT INTO Payment_option (payment_option_id, type_name)
VALUES(nextval('payment_option_seq'), 'credit card');
INSERT INTO Payment_option (payment_option_id, type_name)
VALUES(nextval('payment_option_seq'), 'PayPal');
INSERT INTO Payment_option (payment_option_id, type_name)
VALUES(nextval('payment_option_seq'), 'Affirm');
END$$;
COMMIT;

START TRANSACTION;
DO
$$BEGIN
CALL Add_new_purchase('TJ1985', CAST(250.00 AS money), 'credit card', 'Batman');
CALL Add_new_purchase('NanTheMan', CAST(38.00 AS money), 'PayPal', 'The Audacity of Despair');
CALL Add_new_purchase('bbooks', CAST(78.00 AS money), 'credit card', 'Avengers Forever');
CALL Add_new_purchase('pjtaffington', CAST(78.00 AS money), 'Affirm', 'A Very Old Book');
CALL Add_new_purchase('DorisH34', CAST(56.00 AS money), 'PayPal', 'Travelhood of the Sistering Pants');
CALL Add_new_purchase('fharp5', CAST(188.00 AS money), 'Affirm', 'Fun Times');
CALL Add_new_purchase('patpat56', CAST(66.00 AS money), 'credit card', 'Sad Times');
CALL Add_new_purchase('tinyTim', CAST(116.00 AS money), 'credit card', 'Yet another book');
END$$;
COMMIT;

-- returns
-- This sql won't run out of the box because it relies on the timestamps created by the purchases above.
-- Leaving in the values I used in my db as an example, but to run these you would need to get actual
-- timestmaps for purchases and use those, then uncomment the below lines.
-- START TRANSACTION;
-- DO
-- $$BEGIN
-- CALL Add_new_return('TJ1985', '2023-02-20 14:38:38.367087');
-- CALL Add_new_return('patpat56', '2023-02-20 14:58:49.084568');
-- UPDATE Return
-- SET received_date = '2023-02-01'
-- WHERE return_id = currval('return_seq');
-- CALL Add_new_return('fharp5', '2023-02-20 14:58:49.083862');
-- CALL Add_new_return('DorisH34', '2023-02-20 14:52:38.240451');
-- CALL Add_new_return('DorisH34', '2023-01-18 14:58:49.084568');
-- UPDATE Return
-- SET received_date = '2023-02-01', completed_date = '2023-02-03'
-- WHERE return_id = currval('return_seq');
-- END$$;
-- COMMIT;

-- Trades
START TRANSACTION;
DO
$$BEGIN
CALL Add_new_trade('TJ1985', 'NanTheMan', 'Amazing Spider-Man', 'Pride & Prejudice');
CALL Add_new_trade('TJ1985', 'fharp5', 'Just Another Book Title', 'Astonishing X-Men');
UPDATE Trade
SET accepted_time = '2023-02-21 20:40:37.136758'
WHERE trade_id = currval('trade_seq');
CALL Add_new_trade('DorisH34', 'patpat56', '15 Habits to Make You Rich Now', 'Superman');
UPDATE Trade
SET accepted_time = '2023-03-01 20:40:37.136758'
WHERE trade_id = currval('trade_seq');
CALL Add_new_trade('NanTheMan', 'patpat56', 'Pride & Prejudice', 'Wonder Woman Annual');
CALL Add_new_trade('DorisH34', 'fharp5', 'What are we doing here?', 'Great Working Title');
UPDATE Trade
SET accepted_time = '2023-02-22 20:40:37.136758'
WHERE trade_id = currval('trade_seq');
END$$;
COMMIT;

-- Messages
START TRANSACTION;
DO
$$BEGIN
CALL Add_new_message('TJ1985', 'NanTheMan', 'Hi, this is Tom. I would like to discuss a trade for your copy of Pride & Prejudice.', 
					 'hello!');
CALL Add_new_message('NanTheMan', 'TJ1985', 'Thank you for reaching out, Tom. What would you like to trade?', 
					 'P&P Inquiry');
CALL Add_new_message('TJ1985', 'NanTheMan', 'I have a great copy of a Spider-man Comic book. How about that?', 
					 're:P&P Inquiry');
CALL Add_new_message('NanTheMan', 'TJ1985', 'That sounds great. I want to do the trade.', 
					 're:P&P Inquiry');
CALL Add_new_message('patpat56', 'fharp5', 'Hello! I noticed you have a great book. Where did you find it?', 
					 'Hi from Pat');
CALL Add_new_message('fharp5', 'patpat56', 'I got it from my brother. It is a good book.', 
					 're:Hi from Pat');
CALL Add_new_message('tinyTim', 'fharp5', 'Yo! How are you! Love your comics on site!', 
					 'intro message');
END$$;
COMMIT;

--TRIGGERS

CREATE OR REPLACE FUNCTION List_price_change_trigger_function()
RETURNS TRIGGER LANGUAGE plpgsql
AS $trigfunc$
	BEGIN
		INSERT INTO List_price_change(list_price_change_id, listing_id, old_list_price,
								 new_list_price, change_time)
		VALUES(nextval('list_price_change_seq'), NEW.listing_id,
		  OLD.list_price, NEW.list_price, clock_timestamp());
	RETURN NEW;
	END;
$trigfunc$;

CREATE OR REPLACE TRIGGER List_price_change_trigger
BEFORE UPDATE OF list_price ON Listing
FOR EACH ROW
EXECUTE PROCEDURE List_price_change_trigger_function();

--QUERIES

-- Returned books and their condition
SELECT title, condition, book_type
FROM Book b
JOIN Listing l ON l.book_id = b.book_id
JOIN Purchase p ON p.purchase_id = l.purchase_id
JOIN Return r ON r.purchase_id = p.purchase_id;

-- Users with the most message interactions
SELECT a.username, CONCAT(i.first_name, ' ', i.last_name) as full_name,
       COUNT(m.message_id) as number_of_interactions
FROM Account a
JOIN Individual i ON i.account_id = a.account_id
JOIN Message m ON m.sender_id = i.account_id OR m.recipient_id = i.account_id
GROUP BY a.username, i.first_name, i.last_name
ORDER BY COUNT(m.message_id) DESC;

-- Bookstores with the highest sales
SELECT bs.store_name, SUM(p.purchase_price) as total_sold_on_site
FROM Bookstore bs
JOIN Account a ON bs.account_id = a.account_id
JOIN Listing l ON l.account_id = a.account_id
JOIN Purchase p on l.purchase_id = p.purchase_id
GROUP BY bs.store_name
ORDER BY SUM(p.purchase_price) DESC;

-- Purchases from the last 24 hours
SELECT b.title, p.purchase_price, p.purchase_time
FROM Purchase p
JOIN Listing l ON p.purchase_id = l.purchase_id
JOIN Book b ON l.book_id = b.book_id
WHERE p.purchase_time > clock_timestamp() - interval '24 hours'
ORDER BY p.purchase_time DESC;

-- Listings for User x
SELECT a.username, b.title, (CASE WHEN l.purchase_id IS NULL THEN 'no' ELSE 'yes' END) as has_been_purchased
FROM Account a
JOIN Listing l ON l.account_id = a.account_id
JOIN Book b ON b.book_id = l.book_id
WHERE a.username = 'patpat56';

-- Data Visualization Queries

-- Sales by day
SELECT CAST(date_trunc('day', purchase_time) as date) as date, COUNT(*) as total_sales_for_day
FROM Purchase
WHERE purchase_time > (clock_timestamp() - interval '1 month')
GROUP BY date_trunc('day', purchase_time)
ORDER BY date_trunc('day', purchase_time) ASC;

-- Sales by hour
SELECT CONCAT(extract(hour from purchase_time), ':00') as hour, COUNT(*) as total_sales_for_hour
FROM Purchase
WHERE purchase_time > (clock_timestamp() - interval '1 month')
GROUP BY extract(hour from purchase_time)
ORDER BY extract(hour from purchase_time) ASC;

-- Payment Options
SELECT pt.type_name as payment_option_type,
	   COUNT(p.purchase_id) as number_of_purchases,
       ROUND(100.00 * COUNT(p.payment_option_id) / (SELECT COUNT(purchase_id) FROM Purchase)) as percentage_of_purchases
FROM Payment_Option pt
JOIN Purchase p ON p.payment_option_id = pt.payment_option_id 
GROUP BY type_name;