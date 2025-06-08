CREATE OR REPLACE FUNCTION get_user_by_id(p_id INTEGER)
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