CREATE TABLE topics (
  id INT NOT NULL AUTO_INCREMENT,
  title VARCHAR(32) NOT NULL,
  body TEXT NOT NULL,
  -- timestamp DATETIME NOT NULL,
  category_id INT NOT NULL,
  user_id INT NOT NULL,

  PRIMARY KEY (id)
  -- INDEX (category_id),
  -- FOREIGN KEY (category_id) REFERENCES categories(id)
  --   ON DELETE CASCADE
  --   ON UPDATE CASCADE,
  -- FOREIGN KEY (user_id) REFERENCES user(id)
  --   ON DELETE CASCADE
  --   ON UPDATE CASCADE
    -- ref_opt: RESTRICT | CASCADE | SET NULL | NO ACTION
);

