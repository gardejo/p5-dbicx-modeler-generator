SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `myapp` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
SHOW WARNINGS;
USE `myapp`;

-- -----------------------------------------------------
-- Table `myapp`.`artist`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `myapp`.`artist` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `myapp`.`artist` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(256) NOT NULL ,
  `insert_date_time` DATETIME NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `myapp`.`cd`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `myapp`.`cd` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `myapp`.`cd` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `artist` INT UNSIGNED NOT NULL ,
  `title` VARCHAR(256) NOT NULL ,
  `insert_date_time` DATETIME NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_cd_artist` (`artist` ASC) ,
  CONSTRAINT `fk_cd_artist`
    FOREIGN KEY (`artist` )
    REFERENCES `myapp`.`artist` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `myapp`.`track`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `myapp`.`track` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `myapp`.`track` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `cd` INT UNSIGNED NOT NULL ,
  `title` VARCHAR(256) NOT NULL ,
  `insert_date_time` DATETIME NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_track_cd` (`cd` ASC) ,
  CONSTRAINT `fk_track_cd`
    FOREIGN KEY (`cd` )
    REFERENCES `myapp`.`cd` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
