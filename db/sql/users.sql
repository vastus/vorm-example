DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(32) NOT NULL,
  email VARCHAR(64) NOT NULL,
  password_hash VARCHAR(64) NOT NULL,
  password_salt VARCHAR(64) NOT NULL
);

