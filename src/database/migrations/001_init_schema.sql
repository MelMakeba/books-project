-- Drop tables
DROP TABLE IF EXISTS books CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- Create users 
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create books 
CREATE TABLE IF NOT EXISTS books (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  author VARCHAR(255) NOT NULL,
  publication_year INTEGER NOT NULL,
  isbn VARCHAR(13) NOT NULL UNIQUE,
  description TEXT,
  user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index on book title 
CREATE INDEX IF NOT EXISTS idx_books_title ON books(title);

-- Create index on book ISBN 
CREATE INDEX IF NOT EXISTS idx_books_isbn ON books(isbn);

-- Create index on user email
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

--Stored procedure to count books by publication
CREATE OR REPLACE FUNCTION count_books_by_year()
RETURNS TABLE (year INTEGER, book_count BIGINT) AS $$
BEGIN
  RETURN QUERY
  SELECT publication_year as year, COUNT(*) as book_count
  FROM books
  GROUP BY publication_year
  ORDER BY publication_year DESC;
END;
$$ LANGUAGE plpgsql;

--Stored procedure to get books by user
CREATE OR REPLACE FUNCTION get_books_by_user(user_id_param INTEGER)
RETURNS TABLE (
  id INTEGER,
  title VARCHAR(255),
  author VARCHAR(255),
  publication_year INTEGER,
  isbn VARCHAR(13)
) AS $$
BEGIN
  RETURN QUERY
  SELECT b.id, b.title, b.author, b.publication_year, b.isbn
  FROM books b
  WHERE b.user_id = user_id_param
  ORDER BY b.title;
END;
$$ LANGUAGE plpgsql;

-- Create a trigger 
CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--Books table trigger
CREATE TRIGGER update_books_modtime
BEFORE UPDATE ON books
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();

--Users table trigger 
CREATE TRIGGER update_users_modtime
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();

--seed user and books data

INSERT INTO users (username, email, password_hash, first_name, last_name)
VALUES 
  ('johndoe', 'john@example.com', 'hashed_password_1', 'John', 'Doe'),
  ('janedoe', 'jane@example.com', 'hashed_password_2', 'Jane', 'Doe'),
  ('bobsmith', 'bob@example.com', 'hashed_password_3', 'Bob', 'Smith')
ON CONFLICT (username) DO NOTHING;

DO $$
DECLARE
  user1_id INTEGER;
  user2_id INTEGER;
  user3_id INTEGER;
BEGIN
  SELECT id INTO user1_id FROM users WHERE username = 'johndoe' LIMIT 1;
  SELECT id INTO user2_id FROM users WHERE username = 'janedoe' LIMIT 1;
  SELECT id INTO user3_id FROM users WHERE username = 'bobsmith' LIMIT 1;

  INSERT INTO books (title, author, publication_year, isbn, description, user_id)
  VALUES 
    ('The Great Gatsby', 'F. Scott Fitzgerald', 1925, '9780743273565', 'A novel about the mysterious Jay Gatsby and his obsession with Daisy Buchanan', user1_id),
    ('To Kill a Mockingbird', 'Harper Lee', 1960, '9780061120084', 'A novel about racial injustice in the American South', user1_id),
    ('1984', 'George Orwell', 1949, '9780451524935', 'A dystopian novel set in a totalitarian society', user2_id),
    ('Pride and Prejudice', 'Jane Austen', 1813, '9780141439518', 'A novel of manners about marriage and class', user2_id),
    ('The Catcher in the Rye', 'J.D. Salinger', 1951, '9780316769488', 'A novel about teenage alienation and identity', user3_id),
    ('To the Lighthouse', 'Virginia Woolf', 1927, '9780156907392', 'A modernist novel about the Ramsay family', user3_id),
    ('Brave New World', 'Aldous Huxley', 1932, '9780060850524', 'A dystopian novel about a genetically engineered future society', user1_id)
  ON CONFLICT (isbn) DO NOTHING;
END $$;

