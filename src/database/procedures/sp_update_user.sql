CREATE OR REPLACE PROCEDURE update_user(
  p_id INT,
  p_username VARCHAR,
  p_email VARCHAR, 
  p_password_hash VARCHAR,
  p_first_name VARCHAR,
  p_last_name VARCHAR,
  p_is_active BOOLEAN
)
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE users
  SET 
    username = COALESCE(p_username, username),
    email = COALESCE(p_email, email),
    password_hash = COALESCE(p_password_hash, password_hash),
    first_name = COALESCE(p_first_name, first_name),
    last_name = COALESCE(p_last_name, last_name),
    is_active = COALESCE(p_is_active, is_active),
    updated_at = NOW()
  WHERE users.id = p_id;  
END;
$$;
