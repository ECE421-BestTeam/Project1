USE ece421grp4;
DROP TABLE IF EXISTS Game;
DROP TABLE IF EXISTS Server;
DROP TABLE IF EXISTS Player;
DROP TABLE IF EXISTS Session;

CREATE TABLE IF NOT EXISTS Game(
  game_id varchar(200),
  player1_id Text,
  player2_id Text,
  state Text,
  game_model Text,
  server_address Text,
  last_update Date,
  UNIQUE(game_id),
  PRIMARY KEY(game_id));

CREATE TABLE IF NOT EXISTS Server(
  server_address varchar(200),
  UNIQUE(server_address),
  PRIMARY KEY(server_address));

CREATE TABLE IF NOT EXISTS Session(
  session_id varchar(200),
  player_id Text,
  unique(session_id),
  PRIMARY KEY(session_id));

CREATE TABLE IF NOT EXISTS Player(
  username varchar(200),
  password Text,
  points Integer,
  wins Integer,
  losses Integer,
  draws Integer,
  current_session_id varchar(200),
  UNIQUE(username),
  PRIMARY KEY(username),
  FOREIGN KEY(current_session_id) REFERENCES Session(session_id) ON DELETE CASCADE);





