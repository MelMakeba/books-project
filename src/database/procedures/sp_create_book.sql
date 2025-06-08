CREATE OR REPLACE FUNCTION create_book(
  p_title VARCHAR(255),
  p_author VARCHAR(255),
  p_publication_year INTEGER,
  p_isbn VARCHAR(13),
  p_description TEXT DEFAULT NULL,
  p_user_id INTEGER DEFAULT NULL
)
RETURNS TABLE (
  id INTEGER,
  title VARCHAR(255),
  author VARCHAR(255),
  publication_year INTEGER,
  isbn VARCHAR(13),
  description TEXT,
  user_id INTEGER,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
) AS $$
BEGIN
  RETURN QUERY
  INSERT INTO books (title, author, publication_year, isbn, description, user_id)
  VALUES (p_title, p_author, p_publication_year, p_isbn, p_description, p_user_id)
  RETURNING 
    books.id, 
    books.title, 
    books.author, 
    books.publication_year, 
    books.isbn, 
    books.description, 
    books.user_id, 
    books.created_at, 
    books.updated_at;
END;
$$ LANGUAGE plpgsql;
