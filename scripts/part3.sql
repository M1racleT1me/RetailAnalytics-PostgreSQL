SELECT rolname FROM pg_roles;

CREATE ROLE administrator WITH SUPERUSER LOGIN PASSWORD 'adm123'; -- рут права для пользователя
SELECT rolname FROM pg_roles;

CREATE ROLE visitor WITH LOGIN;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO visitor; -- права на SELECT всех публичных таблиц
SELECT rolname FROM pg_roles;