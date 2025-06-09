CREATE OR REPLACE FUNCTION update_book(
  p_id INTEGER,
  p_title VARCHAR(255) DEFAULT NULL,
  p_author VARCHAR(255) DEFAULT NULL,
  p_publication_year INTEGER DEFAULT NULL,
  p_isbn VARCHAR(13) DEFAULT NULL,
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
    UPDATE books
  SET 
    title = COALESCE(p_title, title),
    author = COALESCE(p_author, author),
    publication_year = COALESCE(p_publication_year, publication_year),
    isbn = COALESCE(p_isbn, isbn),
    description = COALESCE(p_description, description),
    user_id = COALESCE(p_user_id, user_id)
  WHERE books_id = p_id;
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
  WHERE books.id = p_id;
END;
$$ LANGUAGE plpgsql;