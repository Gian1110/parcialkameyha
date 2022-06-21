-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Kameyha
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `Kameyha` ;

-- -----------------------------------------------------
-- Schema Kameyha
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Kameyha` DEFAULT CHARACTER SET utf8 ;
USE `Kameyha` ;

-- -----------------------------------------------------
-- Table `Kameyha`.`Domicilios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Kameyha`.`Domicilios` ;

CREATE TABLE IF NOT EXISTS `Kameyha`.`Domicilios` (
  `idDomicilio` INT NOT NULL,
  `calleYNumero` VARCHAR(60) NOT NULL,
  `codigoPostal` VARCHAR(10) NULL,
  `telefono` VARCHAR(25) NOT NULL,
  `municipio` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`idDomicilio`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `calleYNumero_UNIQUE` ON `Kameyha`.`Domicilios` (`calleYNumero` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Kameyha`.`Clientes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Kameyha`.`Clientes` ;

CREATE TABLE IF NOT EXISTS `Kameyha`.`Clientes` (
  `idCliente` INT NOT NULL,
  `apellidos` VARCHAR(50) NOT NULL,
  `nombres` VARCHAR(50) NOT NULL,
  `correo` VARCHAR(50) NULL,
  `estado` CHAR(1) NOT NULL DEFAULT 'E',
  `idDomicilio` INT NOT NULL,
  PRIMARY KEY (`idCliente`),
  CONSTRAINT `fk_Clientes_Domicilios`
    FOREIGN KEY (`idDomicilio`)
    REFERENCES `Kameyha`.`Domicilios` (`idDomicilio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `CK_cliente_estado` CHECK ((`estado` = _utf8mb4'E') or (`estado` = _utf8mb4'D')))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `correo_UNIQUE` ON `Kameyha`.`Clientes` (`correo` ASC) VISIBLE;

CREATE INDEX `fk_Clientes_Domicilios_idx` ON `Kameyha`.`Clientes` (`idDomicilio` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Kameyha`.`Tiendas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Kameyha`.`Tiendas` ;

CREATE TABLE IF NOT EXISTS `Kameyha`.`Tiendas` (
  `idTienda` INT NOT NULL,
  `idDomicilio` INT NOT NULL,
  PRIMARY KEY (`idTienda`),
  CONSTRAINT `fk_Tiendas_Domicilios1`
    FOREIGN KEY (`idDomicilio`)
    REFERENCES `Kameyha`.`Domicilios` (`idDomicilio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Tiendas_Domicilios1_idx` ON `Kameyha`.`Tiendas` (`idDomicilio` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Kameyha`.`Peliculas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Kameyha`.`Peliculas` ;

CREATE TABLE IF NOT EXISTS `Kameyha`.`Peliculas` (
  `idPelicula` INT NOT NULL,
  `titulo` VARCHAR(128) NOT NULL,
  `clasificacion` VARCHAR(5) NOT NULL DEFAULT 'G',
  `estreno` INT NULL,
  `duracion` INT NULL,
  PRIMARY KEY (`idPelicula`),
  CONSTRAINT `CK_peliculas_clasificacion` CHECK (((`clasificacion` = _utf8mb4'G') or (`clasificacion` = _utf8mb4'PG') or (`clasificacion` = _utf8mb4'PG-13') or (`clasificacion` = _utf8mb4'R') or (`clasificacion` = _utf8mb4'NC-17'))))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `titulo_UNIQUE` ON `Kameyha`.`Peliculas` (`titulo` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Kameyha`.`Registros`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Kameyha`.`Registros` ;

CREATE TABLE IF NOT EXISTS `Kameyha`.`Registros` (
  `idRegistro` INT NOT NULL,
  `idTienda` INT NOT NULL,
  `idPelicula` INT NOT NULL,
  PRIMARY KEY (`idRegistro`),
  CONSTRAINT `fk_Registros_Tiendas1`
    FOREIGN KEY (`idTienda`)
    REFERENCES `Kameyha`.`Tiendas` (`idTienda`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Registros_Peliculas1`
    FOREIGN KEY (`idPelicula`)
    REFERENCES `Kameyha`.`Peliculas` (`idPelicula`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Registros_Tiendas1_idx` ON `Kameyha`.`Registros` (`idTienda` ASC) VISIBLE;

CREATE INDEX `fk_Registros_Peliculas1_idx` ON `Kameyha`.`Registros` (`idPelicula` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Kameyha`.`Alquileres`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Kameyha`.`Alquileres` ;

CREATE TABLE IF NOT EXISTS `Kameyha`.`Alquileres` (
  `idAlquiler` INT NOT NULL,
  `fechaAlquiler` DATETIME NOT NULL,
  `fechaDevolucion` DATETIME NULL,
  `idCliente` INT NOT NULL,
  `idRegistro` INT NOT NULL,
  PRIMARY KEY (`idAlquiler`),
  CONSTRAINT `fk_Alquileres_Clientes1`
    FOREIGN KEY (`idCliente`)
    REFERENCES `Kameyha`.`Clientes` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Alquileres_Registros1`
    FOREIGN KEY (`idRegistro`)
    REFERENCES `Kameyha`.`Registros` (`idRegistro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Alquileres_Clientes1_idx` ON `Kameyha`.`Alquileres` (`idCliente` ASC) VISIBLE;

CREATE INDEX `fk_Alquileres_Registros1_idx` ON `Kameyha`.`Alquileres` (`idRegistro` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Kameyha`.`Pagos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Kameyha`.`Pagos` ;

CREATE TABLE IF NOT EXISTS `Kameyha`.`Pagos` (
  `idPago` INT NOT NULL,
  `idCliente` INT NOT NULL,
  `idAlquiler` INT NOT NULL,
  `importe` DECIMAL(5,2) NOT NULL,
  `fecha` DATETIME NOT NULL,
  PRIMARY KEY (`idPago`),
  CONSTRAINT `fk_Pagos_Clientes1`
    FOREIGN KEY (`idCliente`)
    REFERENCES `Kameyha`.`Clientes` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pagos_Alquileres1`
    FOREIGN KEY (`idAlquiler`)
    REFERENCES `Kameyha`.`Alquileres` (`idAlquiler`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Pagos_Clientes1_idx` ON `Kameyha`.`Pagos` (`idCliente` ASC) VISIBLE;

CREATE INDEX `fk_Pagos_Alquileres1_idx` ON `Kameyha`.`Pagos` (`idAlquiler` ASC) VISIBLE;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


DROP VIEW IF EXISTS  VRankingAlquileres;
CREATE VIEW VRankingAlquileres AS 
SELECT Clientes.idCliente AS idCliente, concat_ws(',',Clientes.apellidos,Clientes.nombres) AS Cliente, COUNT(Peliculas.idPelicula) AS Cantidad
FROM Peliculas INNER JOIN Registros ON Peliculas.idPelicula = Registros.idPelicula
			   INNER JOIN Alquileres ON Registros.idRegistro = Alquileres.idRegistro
               INNER JOIN Clientes ON Alquileres.idCliente = Clientes.idCliente
GROUP BY idCliente, Cliente
ORDER BY Cantidad DESC,Cliente ASC
limit 10;
SELECT * FROM Kameyha.vrankingalquileres;

DROP PROCEDURE IF EXISTS BorrarPelicula;

DELIMITER //
CREATE PROCEDURE BorrarPelicula(idPeliculaB INT,OUT mensaje VARCHAR(100))
SALIR: BEGIN
    
	IF (idPeliculaB IS NULL) THEN
		SET mensaje = 'el id enviado no puede ser nulo';
		LEAVE SALIR;
	ELSEIF not EXISTS (SELECT Peliculas.idPelicula FROM Peliculas WHERE Peliculas.idPelicula = idPeliculaB) THEN
		SET mensaje = 'no existe una pelicula con ese identificador';
        LEAVE SALIR;
	ELSEIF EXISTS (SELECT Registros.idRegistro FROM Registros INNER JOIN Peliculas on Registros.idPelicula = Peliculas.idPelicula WHERE Peliculas.idPelicula = idPeliculaB) THEN
		SET mensaje = 'no se puede borrar dado que la pelicula esta asociada a un registro';
        LEAVE SALIR;
	ELSE
		START TRANSACTION;
		Delete FROM Peliculas where Peliculas.idPelicula = idPeliculaB;
		SET mensaje = 'se borro con exito la pelicula';
        COMMIT;
    END IF;
END//
DELIMITER ;
-- caso nulo
SET @mensaje = NULL;
CALL BorrarPelicula(null,@mensaje);
SELECT @mensaje;
-- caso no existe el id
SET @mensaje = NULL;
CALL BorrarPelicula(1001,@mensaje);
SELECT @mensaje;
-- caso id relacionado con registro
SET @mensaje = NULL;
CALL BorrarPelicula(1,@mensaje);
SELECT @mensaje;
-- caso borrado correcto
INSERT INTO `Peliculas` VALUES (1001,'ACADEMY NOSAUR','PG',2006,86);
SET @mensaje = NULL;
CALL BorrarPelicula(1001,@mensaje);
SELECT @mensaje;

DROP PROCEDURE IF EXISTS TotalAlquileres;

DELIMITER //
CREATE PROCEDURE TotalAlquileres(idClienteB INT)
SALIR: BEGIN
    SELECT Peliculas.idPelicula AS idPelicula,Peliculas.titulo AS Titulo, Count(Peliculas.idPelicula) AS Cantidad
    FROM Peliculas INNER JOIN Registros ON Peliculas.idPelicula = Registros.idPelicula
				   INNER JOIN Alquileres ON Registros.idRegistro = Alquileres.idRegistro
                   RIGHT JOIN Clientes ON Alquileres.idCliente = Clientes.idCliente
    WHERE Clientes.idCliente = idClienteB
    GROUP BY idPelicula, Titulo with ROLLUP
    ORDER BY Titulo ASC;
END//
DELIMITER ;

CALL TotalAlquileres(1);

DROP TRIGGER IF EXISTS crearPelicula;
DELIMITER //
CREATE TRIGGER crearPelicula AFTER INSERT ON Peliculas FOR EACH ROW
BEGIN
	IF EXISTS (SELECT idPelicula FROM Peliculas where Peliculas.idPelicula=new.idPelicula) or (SELECT idPelicula FROM Peliculas where Peliculas.titulo=new.titulo) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede crear la pelicula dado que ya existe el id', MYSQL_ERRNO=45000 ;
    END IF;
END//
DELIMITER ;
INSERT INTO `Peliculas` VALUES (1001,'ACADEMy NOSAUR','PG',2006,86);
