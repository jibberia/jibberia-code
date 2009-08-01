-- run this as root:
-- $ mysql -uroot -p < initdb.sql

drop database if exists symphony_server;
create database symphony_server;
grant all on symphony_server.* to 'symphony'@'localhost' identified by 'argon412';
grant all on symphony_server.* to '%'@'localhost';
