
CREATE TABLE IF NOT EXISTS `dms_flyjob` (
  `id` INT(20) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `exp` int(50) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
