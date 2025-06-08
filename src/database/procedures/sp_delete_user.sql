CREATE OR REPLACE FUNCTION delete_user(p_id INTEGER)
RETURNS BOOLEAN AS $$
DECLARE
  user_exists BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM users WHERE id = p_id) INTO user_exists;
  IF user_exists THEN
    DELETE FROM users WHERE id = p_id;
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
END;
$$ LANGUAGE plpgsql;