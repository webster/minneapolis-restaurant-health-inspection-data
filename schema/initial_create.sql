DROP TABLE IF EXISTS `inspection_order`;
DROP TABLE IF EXISTS `code`;
DROP TABLE IF EXISTS `business_license`;
DROP TABLE IF EXISTS `business`;

CREATE TABLE `business` (
  `business_id`  int unsigned NOT NULL auto_increment,
  -- Max length in data was 50
  `name`         varchar(64) NOT NULL,
  -- Max length in data was 55
  `address`      varchar(64) NOT NULL,
  `city`         varchar(64) NOT NULL,
  `state`        varchar(2)  NOT NULL,
  `postal`       varchar(10) NOT NULL,
  `country`      varchar(2)  NOT NULL,
  PRIMARY KEY    ( `business_id` ),
  UNIQUE KEY     ( `name`, `address`, `city`, `state`, `postal`, `country` )
) ENGINE=InnoDB;

CREATE TABLE `business_license` (
  `business_license_id`  int unsigned NOT NULL auto_increment,
  `business_id`          int unsigned NOT NULL,
  `license_number`       smallint unsigned NOT NULL,
  PRIMARY KEY            ( `business_license_id` ),
  KEY                    ( `license_number` ),
  FOREIGN KEY            ( `business_id` ) REFERENCES `business` ( `business_id` )
                           ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `code` (
  `code_id`       int unsigned NOT NULL auto_increment,
  `code_section`  varchar(32) NOT NULL,
  `code_text`     text NOT NULL DEFAULT "",
  PRIMARY KEY     ( `code_id` ),
  UNIQUE KEY      ( `code_section` )
) ENGINE=InnoDB;

CREATE TABLE `inspection_order` (
  `inspection_order_id`   int unsigned NOT NULL auto_increment,
  `inspection_id`         int unsigned NOT NULL,
  `license_number`        smallint unsigned NOT NULL,
  `license_code`          smallint unsigned DEFAULT NULL,
  `dh_facility_id`        varchar(32) DEFAULT NULL,
  `kind`                  varchar(64) DEFAULT NULL,
  `purpose`               varchar(32) DEFAULT NULL,
  `inspected_on`          date DEFAULT NULL,
  `cco`                   varchar(32) DEFAULT NULL,
  `risk_level`            tinyint unsigned DEFAULT NULL,
  `code_section`          varchar(32) NOT NULL,
  `is_critical`           bool NOT NULL DEFAULT 0,
  PRIMARY KEY             ( `inspection_order_id` ),
  KEY                     ( `inspection_id` ),
  FOREIGN KEY             ( `license_number` ) REFERENCES `business_license` ( `license_number` )
                            ON DELETE CASCADE
) ENGINE=InnoDB;
