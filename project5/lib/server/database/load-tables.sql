USE ece421grp4;
DROP TABLE IF EXISTS Game;
DROP TABLE IF EXISTS Server;
DROP TABLE IF EXISTS Player;

CREATE TABLE IF NOT EXISTS Game(
  game_id varchar(10),
  player1_id Text,
  player2_id Text,
  state Text,
  game_model Text,
  server_address Text,
  last_update Date,
  UNIQUE(game_id),
  PRIMARY KEY(game_id))
CHARACTER SET utf8;

CREATE TABLE IF NOT EXISTS Server(
  server_address varchar(20),
  data varchar(200),
  UNIQUE(server_address),
  PRIMARY KEY(server_address))
CHARACTER SET utf8;

CREATE TABLE IF NOT EXISTS Player(
  username varchar(200),
  password Text,
  points Integer,
  wins Integer,
  losses Integer,
  draws Integer,
  current_session_id varchar(20),
  PRIMARY KEY(username))
CHARACTER SET utf8;





