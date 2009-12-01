-- -----------------------------------------------------
-- Table `artist`
-- -----------------------------------------------------
DROP TABLE IF EXISTS artist;
CREATE TABLE artist (
  id                INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  name              TEXT NOT NULL,
  insert_date_time  DATE NOT NULL DEFAULT current_timestamp
);
CREATE INDEX artist_idx_id ON artist (id);

-- -----------------------------------------------------
-- Table `cd`
-- -----------------------------------------------------
DROP TABLE IF EXISTS cd;
CREATE TABLE cd (
  id                INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  artist            INTEGER NOT NULL,
  title             TEXT NOT NULL,
  insert_date_time  DATE NOT NULL DEFAULT current_timestamp
);
CREATE INDEX cd_idx_id ON cd (id);

-- -----------------------------------------------------
-- Table `track`
-- -----------------------------------------------------
DROP TABLE IF EXISTS track;
CREATE TABLE track (
  id                INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  cd                INTEGER NOT NULL,
  title             TEXT NOT NULL,
  insert_date_time  DATE NOT NULL DEFAULT current_timestamp
);
CREATE INDEX track_idx_id ON track (id);
