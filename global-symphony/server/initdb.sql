-- run this as root:
-- $ mysql -uroot -p < initdb.sql

create database symphony_server;
grant all on symphony_server.* to 'symphony'@'localhost' identified by 'argon412';
