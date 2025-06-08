CREATE OR REPLACE FUNCTION update_user(
  p_id INTEGER,
  p_email VARCHAR(255) DEFAULT NULL,
  p_password_hash VARCHAR(255) DEFAULT NULL,
  p_first_name VARCHAR(100) DEFAULT NULL,
  p_last_name VARCHAR(100) DEFAULT NULL,
  p_is_active BOOLEAN DEFAULT NULL
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
    UPDATE users
  SET 
    email = COALESCE(p_email, email),
    password_hash = COALESCE(p_password_hash, password_hash),
    first_name = COALESCE(p_first_name, first_name),
    last_name = COALESCE(p_last_name, last_name),
    is_active = COALESCE(p_is_active, is_active),
    updated_at = NOW()
  WHERE id = p_id;
RETURN QUERY
  SELECT 
    users.id, 
    users.username, 
    users.email, 
    users.first_name, 
    users.last_name, 
    users.is_active, 
    users.created_at, 
    users.updated_at
  FROM users
  WHERE users.id = p_id;
END;
$$ LANGUAGE plpgsql;
