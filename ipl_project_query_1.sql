-- 1. Create a new PostgreSQL user named ipl_user
--    and assign a password to the user.

CREATE USER ipl_user
WITH PASSWORD '******';


-- 2. Create a new database named ipl_db
--    and assign ipl_user as the database owner.

CREATE DATABASE ipl_db
WITH OWNER = ipl_user;


-- 3. Retrieve the database name and its owner.
--    This query verifies whether ipl_db is owned by ipl_user.

SELECT
    datname AS database_name,
    pg_get_userbyid(datdba) AS owner
FROM pg_database
WHERE datname = 'ipl_db';


-- 4. Display the names of all databases
--    available in the PostgreSQL server.

SELECT datname
FROM pg_database;


-- 5. Display all table names from the public schema
--    of the currently connected database.
--    This helps verify which tables have been created.

SELECT tablename
FROM pg_tables
WHERE schemaname = 'public';
