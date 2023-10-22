CREATE TABLE `players` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`identifier` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`firstname` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`lastname` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `identifier` (`identifier`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;
