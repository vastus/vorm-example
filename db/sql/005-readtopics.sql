DROP TABLE IF EXISTS readtopics;
CREATE TABLE readtopics (
  id INT NOT NULL AUTO_INCREMENT,
  user_id INT NOT NULL,
  topic_id INT NOT NULL,

  PRIMARY KEY (id)
);

