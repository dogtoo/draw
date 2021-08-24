CREATE TABLE user_login (
  id int NOT NULL AUTO_INCREMENT,
  active_time datetime(6) NOT NULL,
  login_ip varchar(20) NOT NULL,
  login_time datetime(6) NOT NULL,
  logout_time datetime(6) DEFAULT NULL,
  status int NOT NULL,
  token varchar(100) DEFAULT NULL,
  user_id int NOT NULL,
  token_hash varchar(100) DEFAULT NULL,
  PRIMARY KEY (id)
);
