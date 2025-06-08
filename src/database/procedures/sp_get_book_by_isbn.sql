CREATE OR REPLACE FUNCTION get_book_by_isbn(p_isbn VARCHAR(13))
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
  SELECT 
    books.id, 
    books.title, 
    books.author, 
    books.publication_year, 
    books.isbn, 
    books.description, 
    books.user_id, 
    books.created_at, 
    books.updated_at
  FROM books
  WHERE books.isbn = p_isbn;
END;
$$ LANGUAGE plpgsql;