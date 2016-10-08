-- MySQL Script generated by MySQL Workbench
-- Sat 08 Oct 2016 08:48:49 AM CEST
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema internal
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `internal` ;

-- -----------------------------------------------------
-- Schema internal
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `internal` DEFAULT CHARACTER SET utf8 ;
USE `internal` ;

-- -----------------------------------------------------
-- Table `internal`.`entity`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `internal`.`entity` ;

CREATE TABLE IF NOT EXISTS `internal`.`entity` (
  `entity_id` INT(11) UNSIGNED NOT NULL,
  `type` VARCHAR(45) NULL,
  `created_at` DATETIME NULL,
  `updated_at` DATETIME NULL,
  `deleted_at` DATETIME NULL,
  `title` VARCHAR(80) NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`entity_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `internal`.`rfid`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `internal`.`rfid` ;

CREATE TABLE IF NOT EXISTS `internal`.`rfid` (
  `entity_id` INT(11) UNSIGNED NOT NULL,
  `active` TINYINT(1) NOT NULL,
  `tagid` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`entity_id`),
  UNIQUE INDEX `tagid` (`tagid` ASC),
  CONSTRAINT `fk_rfid_1`
    FOREIGN KEY (`entity_id`)
    REFERENCES `internal`.`entity` (`entity_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `internal`.`member`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `internal`.`member` ;

CREATE TABLE IF NOT EXISTS `internal`.`member` (
  `entity_id` INT(11) UNSIGNED NOT NULL,
  `member_number` INT UNSIGNED NULL,
  `email` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NULL DEFAULT NULL,
  `reset_token` CHAR(34) NULL DEFAULT NULL,
  `reset_expire` INT(11) NULL DEFAULT NULL,
  `firstname` VARCHAR(255) NULL DEFAULT NULL,
  `lastname` VARCHAR(255) NULL DEFAULT NULL,
  `civicregno` CHAR(13) NULL DEFAULT NULL,
  `company` VARCHAR(255) NULL DEFAULT NULL,
  `orgno` VARCHAR(12) NULL DEFAULT NULL,
  `address_street` VARCHAR(255) NULL DEFAULT NULL,
  `address_extra` VARCHAR(255) NULL DEFAULT NULL,
  `address_zipcode` INT(11) NULL DEFAULT NULL,
  `address_city` VARCHAR(64) NULL DEFAULT NULL,
  `address_country` CHAR(2) NULL DEFAULT 'SE',
  `phone` VARCHAR(64) NULL DEFAULT NULL,
  PRIMARY KEY (`entity_id`),
  UNIQUE INDEX `email` (`email` ASC),
  CONSTRAINT `fk_member_1`
    FOREIGN KEY (`entity_id`)
    REFERENCES `internal`.`entity` (`entity_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `internal`.`config`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `internal`.`config` ;

CREATE TABLE IF NOT EXISTS `internal`.`config` (
  `key` VARCHAR(64) NOT NULL COMMENT 'Config key-name',
  `value` VARCHAR(2048) NULL DEFAULT NULL,
  `desc` VARCHAR(255) NULL DEFAULT NULL COMMENT 'Optional description of config',
  PRIMARY KEY (`key`));


-- -----------------------------------------------------
-- Table `internal`.`logins`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `internal`.`logins` ;

CREATE TABLE IF NOT EXISTS `internal`.`logins` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `member_id` INT(11) UNSIGNED NULL DEFAULT NULL,
  `ip_address` VARCHAR(64) NOT NULL,
  `timestamp` INT(11) NOT NULL,
  `valid` TINYINT(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  INDEX `user_id` (`member_id` ASC));


-- -----------------------------------------------------
-- Table `internal`.`accounting_category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `internal`.`accounting_category` ;

CREATE TABLE IF NOT EXISTS `internal`.`accounting_category` (
  `entity_id` INT(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`entity_id`),
  CONSTRAINT `fk_accounting_category_1`
    FOREIGN KEY (`entity_id`)
    REFERENCES `internal`.`entity` (`entity_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `internal`.`accounting_verification_series`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `internal`.`accounting_verification_series` ;

CREATE TABLE IF NOT EXISTS `internal`.`accounting_verification_series` (
  `entity_id` INT(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`entity_id`),
  UNIQUE INDEX `entity_id_UNIQUE` (`entity_id` ASC),
  CONSTRAINT `fk_accounting_verification_series_1`
    FOREIGN KEY (`entity_id`)
    REFERENCES `internal`.`entity` (`entity_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `internal`.`accounting_period`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `internal`.`accounting_period` ;

CREATE TABLE IF NOT EXISTS `internal`.`accounting_period` (
  `entity_id` INT(11) UNSIGNED NOT NULL,
  `name` VARCHAR(45) NULL,
  `start` DATETIME NULL,
  `end` DATETIME NULL,
  PRIMARY KEY (`entity_id`),
  UNIQUE INDEX `entity_id_UNIQUE` (`entity_id` ASC),
  CONSTRAINT `fk_accounting_period_1`
    FOREIGN KEY (`entity_id`)
    REFERENCES `internal`.`entity` (`entity_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `internal`.`accounting_instruction`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `internal`.`accounting_instruction` ;

CREATE TABLE IF NOT EXISTS `internal`.`accounting_instruction` (
  `entity_id` INT(11) UNSIGNED NOT NULL,
  `instruction_number` INT(11) UNSIGNED NULL,
  `accounting_date` DATE NULL,
  `accounting_category` INT(11) UNSIGNED NULL,
  `importer` VARCHAR(45) NULL,
  `external_id` VARCHAR(255) NULL,
  `external_date` DATE NULL,
  `external_text` TEXT NULL,
  `external_data` TEXT NULL DEFAULT NULL,
  `accounting_verification_series` INT(11) NULL,
  `accounting_period` INT NOT NULL,
  PRIMARY KEY (`entity_id`),
  INDEX `accounting_category` (`accounting_category` ASC),
  INDEX `accounting_verification_series` (`accounting_verification_series` ASC),
  INDEX `instruction_number` (`instruction_number` ASC),
  INDEX `accounting_date` (`accounting_date` ASC),
  INDEX `index6` (`importer` ASC),
  INDEX `fk_accounting_instruction_4_idx` (`accounting_period` ASC),
  INDEX `index8` (`accounting_period` ASC),
  CONSTRAINT `fk_accounting_instruction_1`
    FOREIGN KEY (`accounting_category`)
    REFERENCES `internal`.`accounting_category` (`entity_id`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_accounting_instruction_2`
    FOREIGN KEY (`accounting_verification_series`)
    REFERENCES `internal`.`accounting_verification_series` (`entity_id`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_accounting_instruction_3`
    FOREIGN KEY (`entity_id`)
    REFERENCES `internal`.`entity` (`entity_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_accounting_instruction_4`
    FOREIGN KEY (`accounting_period`)
    REFERENCES `internal`.`accounting_period` (`entity_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `internal`.`accounting_account`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `internal`.`accounting_account` ;

CREATE TABLE IF NOT EXISTS `internal`.`accounting_account` (
  `entity_id` INT(11) UNSIGNED NOT NULL,
  `account_number` INT UNSIGNED NOT NULL,
  `accounting_period` INT(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`entity_id`),
  INDEX `fk_accounting_account_1_idx` (`accounting_period` ASC),
  CONSTRAINT `fk_accounting_account_1`
    FOREIGN KEY (`accounting_period`)
    REFERENCES `internal`.`accounting_period` (`entity_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_accounting_account_2`
    FOREIGN KEY (`entity_id`)
    REFERENCES `internal`.`entity` (`entity_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `internal`.`accounting_cost_center`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `internal`.`accounting_cost_center` ;

CREATE TABLE IF NOT EXISTS `internal`.`accounting_cost_center` (
  `entity_id` INT(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`entity_id`),
  CONSTRAINT `fk_accounting_cost_center_1`
    FOREIGN KEY (`entity_id`)
    REFERENCES `internal`.`entity` (`entity_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `internal`.`accounting_transaction`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `internal`.`accounting_transaction` ;

CREATE TABLE IF NOT EXISTS `internal`.`accounting_transaction` (
  `entity_id` INT(11) UNSIGNED NOT NULL,
  `accounting_instruction` INT(11) UNSIGNED NOT NULL,
  `accounting_account` INT(11) UNSIGNED NOT NULL,
  `accounting_cost_center` INT(11) UNSIGNED NULL,
  `amount` INT NULL,
  `external_id` VARCHAR(45) NULL,
  PRIMARY KEY (`entity_id`),
  INDEX `fk_accounting_transactions_1_idx` (`accounting_instruction` ASC),
  INDEX `fk_accounting_transactions_2_idx` (`accounting_account` ASC),
  INDEX `fk_accounting_transactions_3_idx` (`accounting_cost_center` ASC),
  CONSTRAINT `fk_accounting_transactions_1`
    FOREIGN KEY (`accounting_instruction`)
    REFERENCES `internal`.`accounting_instruction` (`entity_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_accounting_transactions_2`
    FOREIGN KEY (`accounting_account`)
    REFERENCES `internal`.`accounting_account` (`entity_id`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_accounting_transactions_3`
    FOREIGN KEY (`accounting_cost_center`)
    REFERENCES `internal`.`accounting_cost_center` (`entity_id`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_accounting_transaction_1`
    FOREIGN KEY (`entity_id`)
    REFERENCES `internal`.`entity` (`entity_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `internal`.`transaction_member`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `internal`.`transaction_member` ;

CREATE TABLE IF NOT EXISTS `internal`.`transaction_member` (
  `member_id` INT(11) UNSIGNED NOT NULL,
  `accounting_transaction_id` INT(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`member_id`),
  INDEX `fk_transaction_member_2_idx` (`accounting_transaction_id` ASC),
  CONSTRAINT `fk_transaction_member_1`
    FOREIGN KEY (`member_id`)
    REFERENCES `internal`.`member` (`entity_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transaction_member_2`
    FOREIGN KEY (`accounting_transaction_id`)
    REFERENCES `internal`.`accounting_transaction` (`entity_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `internal`.`product`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `internal`.`product` ;

CREATE TABLE IF NOT EXISTS `internal`.`product` (
  `entity_id` INT(11) UNSIGNED NOT NULL,
  `expiry_date` DATETIME NULL,
  `auto_extend` INT(1) NOT NULL,
  `price` INT NULL,
  `interval` VARCHAR(120) NULL,
  PRIMARY KEY (`entity_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `internal`.`subscription`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `internal`.`subscription` ;

CREATE TABLE IF NOT EXISTS `internal`.`subscription` (
  `entity_id` INT(11) UNSIGNED NOT NULL,
  `member_id` INT(11) UNSIGNED NOT NULL,
  `product_id` INT(11) UNSIGNED NOT NULL,
  `date_start` DATETIME NULL,
  PRIMARY KEY (`member_id`),
  INDEX `fk_subscription_1_idx` (`entity_id` ASC),
  INDEX `fk_subscription_3_idx` (`product_id` ASC),
  CONSTRAINT `fk_subscription_1`
    FOREIGN KEY (`member_id`)
    REFERENCES `internal`.`member` (`entity_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_subscription_2`
    FOREIGN KEY (`entity_id`)
    REFERENCES `internal`.`entity` (`entity_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_subscription_3`
    FOREIGN KEY (`product_id`)
    REFERENCES `internal`.`product` (`entity_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `internal`.`transaction_subscription`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `internal`.`transaction_subscription` ;

CREATE TABLE IF NOT EXISTS `internal`.`transaction_subscription` (
  `subscription_id` INT(11) UNSIGNED NOT NULL,
  `accounting_transaction_id` INT(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`subscription_id`, `accounting_transaction_id`),
  INDEX `fk_labaccess_transaction_2_idx` (`accounting_transaction_id` ASC),
  CONSTRAINT `fk_labaccess_transaction_1`
    FOREIGN KEY (`subscription_id`)
    REFERENCES `internal`.`subscription` (`member_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_labaccess_transaction_2`
    FOREIGN KEY (`accounting_transaction_id`)
    REFERENCES `internal`.`accounting_transaction` (`entity_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `internal`.`invoice`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `internal`.`invoice` ;

CREATE TABLE IF NOT EXISTS `internal`.`invoice` (
  `entity_id` INT(11) UNSIGNED NOT NULL,
  `invoice_number` INT UNSIGNED NULL,
  `date_invoice` DATE NULL,
  `conditions` INT(3) NULL,
  `our_reference` VARCHAR(80) NULL,
  `your_reference` VARCHAR(80) NULL,
  `address` TEXT NULL,
  `status` VARCHAR(45) NULL,
  `currency` VARCHAR(3) NULL,
  `accounting_period` INT(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`entity_id`),
  INDEX `index2` (`invoice_number` ASC),
  INDEX `index3` (`date_invoice` ASC),
  INDEX `index4` (`status` ASC),
  INDEX `index5` (`accounting_period` ASC),
  CONSTRAINT `fk_invoice_1`
    FOREIGN KEY (`entity_id`)
    REFERENCES `internal`.`entity` (`entity_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_invoice_2`
    FOREIGN KEY (`accounting_period`)
    REFERENCES `internal`.`accounting_period` (`entity_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `internal`.`invoice_post`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `internal`.`invoice_post` ;

CREATE TABLE IF NOT EXISTS `internal`.`invoice_post` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `entity_id` INT(11) UNSIGNED NOT NULL,
  `type` VARCHAR(20) NULL,
  `title` TEXT NULL,
  `price` INT NULL,
  `vat` INT(3) NULL,
  `amount` INT NULL,
  `unit` VARCHAR(20) NULL,
  `weight` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_invoice_post_1_idx` (`entity_id` ASC),
  CONSTRAINT `fk_invoice_post_1`
    FOREIGN KEY (`entity_id`)
    REFERENCES `internal`.`invoice` (`entity_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `internal`.`entity_revision`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `internal`.`entity_revision` ;

CREATE TABLE IF NOT EXISTS `internal`.`entity_revision` (
  `entity_id` INT(11) UNSIGNED NOT NULL,
  `revision_date` DATETIME NULL,
  PRIMARY KEY (`entity_id`),
  CONSTRAINT `fk_entity_revision_1`
    FOREIGN KEY (`entity_id`)
    REFERENCES `internal`.`entity` (`entity_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `internal`.`relation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `internal`.`relation` ;

CREATE TABLE IF NOT EXISTS `internal`.`relation` (
  `entity1` INT(11) UNSIGNED NOT NULL,
  `entity2` INT(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`entity2`, `entity1`),
  INDEX `fk_relation_1_idx` (`entity1` ASC),
  CONSTRAINT `fk_relation_1`
    FOREIGN KEY (`entity1`)
    REFERENCES `internal`.`entity` (`entity_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_relation_2`
    FOREIGN KEY (`entity2`)
    REFERENCES `internal`.`entity` (`entity_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `internal`.`mail`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `internal`.`mail` ;

CREATE TABLE IF NOT EXISTS `internal`.`mail` (
  `entity_id` INT(11) UNSIGNED NOT NULL,
  `type` VARCHAR(45) NULL,
  `recipient` VARCHAR(120) NULL,
  `date_sent` DATETIME NULL,
  `status` VARCHAR(45) NULL,
  PRIMARY KEY (`entity_id`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `internal`.`entity`
-- -----------------------------------------------------
START TRANSACTION;
USE `internal`;
INSERT INTO `internal`.`entity` (`entity_id`, `type`, `created_at`, `updated_at`, `deleted_at`, `title`, `description`) VALUES (1, 'accounting_period', NULL, NULL, NULL, 'Räkneskapsår 2013', NULL);
INSERT INTO `internal`.`entity` (`entity_id`, `type`, `created_at`, `updated_at`, `deleted_at`, `title`, `description`) VALUES (2, 'accounting_period', NULL, NULL, NULL, 'Räkneskapsår 2014', NULL);
INSERT INTO `internal`.`entity` (`entity_id`, `type`, `created_at`, `updated_at`, `deleted_at`, `title`, `description`) VALUES (3, 'accounting_period', NULL, NULL, NULL, 'Räkneskapsår 2015', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `internal`.`accounting_period`
-- -----------------------------------------------------
START TRANSACTION;
USE `internal`;
INSERT INTO `internal`.`accounting_period` (`entity_id`, `name`, `start`, `end`) VALUES (1, '2013', '2013-01-01', '2013-12-31');
INSERT INTO `internal`.`accounting_period` (`entity_id`, `name`, `start`, `end`) VALUES (2, '2014', '2014-01-01', '2014-12-31');
INSERT INTO `internal`.`accounting_period` (`entity_id`, `name`, `start`, `end`) VALUES (3, '2015', '2015-01-01', '2015-12-31');

COMMIT;

