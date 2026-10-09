-- Create the user

CREATE DATABASE shumama;

CREATE ROLE mcp_readonly WITH LOGIN PASSWORD 'password';

-- Grant connection to your database
GRANT CONNECT ON DATABASE shumama TO mcp_readonly;

-- Connect to the database and grant schema/table read access
\c shumama;


GRANT USAGE ON SCHEMA public TO mcp_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO mcp_readonly;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO mcp_readonly;
