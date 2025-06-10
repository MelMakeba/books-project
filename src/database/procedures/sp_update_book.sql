CREATE OR REPLACE PROCEDURE update_book(
  p_id INT,
  p_title VARCHAR,
  p_author VARCHAR, 
  p_publication_year INT,
  p_isbn VARCHAR,
  p_description TEXT,
  p_user_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE books
  SET 
    title = COALESCE(p_title, title),
    author = COALESCE(p_author, author),
    publication_year = COALESCE(p_publication_year, publication_year),
    isbn = COALESCE(p_isbn, isbn),
    description = COALESCE(p_description, description),
    user_id = COALESCE(p_user_id, user_id),
    updated_at = NOW()
  WHERE books.id = p_id;  -- Fix: Fully qualify the id column with the table name
END;
$$;