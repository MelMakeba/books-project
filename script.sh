#!/bin/bash

echo "Setting up Book Catalog DB....."

# Create the database
psql -U postgres -h localhost -c "CREATE DATABASE book_catalog;"

# Run migrations 
psql -U postgres -h localhost -d book_catalog -f src/database/migrations/001_init_schema.sql

#Run the stored procedured
psql -U postgres -h localhost -d book_catalog -f src/database/procedures/sp_create_user.sql
psql -U postgres -h localhost -d book_catalog -f src/database/procedures/sp_create_book.sql
psql -U postgres -h localhost -d book_catalog -f src/database/procedures/sp_get_book_by_id.sql
psql -U postgres -h localhost -d book_catalog -f src/database/procedures/sp_get_user_by_id.sql
psql -U postgres -h localhost -d book_catalog -f src/database/procedures/sp_get_all_books.sql
psql -U postgres -h localhost -d book_catalog -f src/database/procedures/sp_get_all_users.sql
psql -U postgres -h localhost -d book_catalog -f src/database/procedures/sp_update_book.sql
psql -U postgres -h localhost -d book_catalog -f src/database/procedures/sp_update_user.sql
psql -U postgres -h localhost -d book_catalog -f src/database/procedures/sp_delete_book.sql
psql -U postgres -h localhost -d book_catalog -f src/database/procedures/sp_delete_user.sql
psql -U postgres -h localhost -d book_catalog -f src/database/procedures/sp_get_user_by_Usrname.sql
psql -U postgres -h localhost -d book_catalog -f src/database/procedures/sp_get_book_by_isbn.sql
psql -U postgres -h localhost -d book_catalog -f src/database/procedures/sp_get_book_by_user.sql

echo "DATABASE setup complete..."

echo "You can now run: npm run start:dev"