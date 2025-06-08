CREATE OR REPLACE FUNCTION delete_book(p_id INTEGER)
RETURNS BOOLEAN AS $$
DECLARE
  book_exists BOOLEAN;
BEGIN
     SELECT EXISTS(SELECT 1 FROM books WHERE id = p_id) INTO book_exists;
  IF book_exists THEN
    DELETE FROM books WHERE id = p_id;
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
END;
$$ LANGUAGE plpgsql;