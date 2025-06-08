CREATE OR REPLACE FUNCTION get_all_books()
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
  ORDER BY books.id;
END;
$$ LANGUAGE plpgsql;