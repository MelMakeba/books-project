CREATE OR REPLACE FUNCTION create_user(
  p_username VARCHAR(50),
  p_email VARCHAR(255),
  p_password_hash VARCHAR(255),
  p_first_name VARCHAR(100),
  p_last_name VARCHAR(100)
) 
RETURNS TABLE (
  id INTEGER,
  username VARCHAR(50),
  email VARCHAR(255),
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  is_active BOOLEAN,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
) AS $$
BEGIN
  RETURN QUERY
  INSERT INTO users (username, email, password_hash, first_name, last_name)
  VALUES (p_username, p_email, p_password_hash, p_first_name, p_last_name)
  RETURNING 
    users.id, 
    users.username, 
    users.email, 
    users.first_name, 
    users.last_name, 
    users.is_active, 
    users.created_at, 
    users.updated_at;
END;
$$ LANGUAGE plpgsql;