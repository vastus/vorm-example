CREATE TABLE replies (
  id INT NOT NULL AUTO_INCREMENT,
  message TEXT NOT NULL,
  topic_id INT NOT NULL,
  user_id INT NOT NULL,

  PRIMARY KEY (id)
);

