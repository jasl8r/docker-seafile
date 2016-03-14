/* Create EmailUser table for administrator. */
/* Taken from /net/user/user-mgr.c at https://github.com/haiwen/ccnet */
CREATE TABLE IF NOT EXISTS EmailUser (
  `id` INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `email` VARCHAR(255), passwd VARCHAR(256),
  `is_staff` BOOL NOT NULL,
  `is_active` BOOL NOT NULL,
  `ctime` BIGINT,
  UNIQUE INDEX (`email`)
) ENGINE=INNODB;
