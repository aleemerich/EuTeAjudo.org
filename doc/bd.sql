-- MySQL Administrator dump 1.4
--
-- ------------------------------------------------------
-- Server version	5.1.54-rel12.6-log


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


--
-- Create schema euteajudo1
--

CREATE DATABASE IF NOT EXISTS euteajudo1;
USE euteajudo1;

--
-- Definition of table `euteajudo1`.`amigo_bloqueados`
--

DROP TABLE IF EXISTS `euteajudo1`.`amigo_bloqueados`;
CREATE TABLE  `euteajudo1`.`amigo_bloqueados` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `amigo_id` int(11) DEFAULT NULL,
  `amigo_id_bloq` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `motivo` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `euteajudo1`.`amigo_bloqueados`
--

/*!40000 ALTER TABLE `amigo_bloqueados` DISABLE KEYS */;
LOCK TABLES `amigo_bloqueados` WRITE;
UNLOCK TABLES;
/*!40000 ALTER TABLE `amigo_bloqueados` ENABLE KEYS */;


--
-- Definition of table `euteajudo1`.`amigo_conversa_controles`
--

DROP TABLE IF EXISTS `euteajudo1`.`amigo_conversa_controles`;
CREATE TABLE  `euteajudo1`.`amigo_conversa_controles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `amigo_id` int(11) NOT NULL,
  `conversa_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `flagNovidade` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`,`amigo_id`,`conversa_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=164 DEFAULT CHARSET=latin1;

--
-- Definition of table `euteajudo1`.`amigo_denuncias`
--

DROP TABLE IF EXISTS `euteajudo1`.`amigo_denuncias`;
CREATE TABLE  `euteajudo1`.`amigo_denuncias` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `amigo_id` int(11) DEFAULT NULL,
  `amigo_id_denunciado` int(11) DEFAULT NULL,
  `dialogo_id` int(11) DEFAULT NULL,
  `texto` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `euteajudo1`.`amigo_denuncias`
--

/*!40000 ALTER TABLE `amigo_denuncias` DISABLE KEYS */;
LOCK TABLES `amigo_denuncias` WRITE;
UNLOCK TABLES;
/*!40000 ALTER TABLE `amigo_denuncias` ENABLE KEYS */;


--
-- Definition of table `euteajudo1`.`amigos`
--

DROP TABLE IF EXISTS `euteajudo1`.`amigos`;
CREATE TABLE  `euteajudo1`.`amigos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nomeCompleto` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `senha` varchar(255) DEFAULT NULL,
  `cidade` varchar(255) DEFAULT NULL,
  `estado` varchar(255) DEFAULT NULL,
  `cpf` varchar(255) DEFAULT NULL,
  `telefone` varchar(255) DEFAULT NULL,
  `profissao` varchar(255) DEFAULT NULL,
  `nivelPermissao` int(11) DEFAULT NULL,
  `stringValidacao` varchar(255) DEFAULT NULL,
  `dataValidacao` datetime DEFAULT NULL,
  `reenvioSenha` int(11) DEFAULT NULL,
  `statusBloqueio` int(11) DEFAULT NULL,
  `flagAvisos` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=112 DEFAULT CHARSET=latin1;

--
-- Definition of table `euteajudo1`.`conversas`
--

DROP TABLE IF EXISTS `euteajudo1`.`conversas`;
CREATE TABLE  `euteajudo1`.`conversas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `assunto` varchar(255) DEFAULT NULL,
  `amigo_id` int(11) DEFAULT NULL,
  `flagColaboracaoUnica` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=latin1;

--
-- Definition of table `euteajudo1`.`dialogos`
--

DROP TABLE IF EXISTS `euteajudo1`.`dialogos`;
CREATE TABLE  `euteajudo1`.`dialogos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `conversa_id` int(11) DEFAULT NULL,
  `amigo_id` int(11) DEFAULT NULL,
  `texto` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=362 DEFAULT CHARSET=latin1;

--
-- Definition of table `euteajudo1`.`log_acessos`
--

DROP TABLE IF EXISTS `euteajudo1`.`log_acessos`;
CREATE TABLE  `euteajudo1`.`log_acessos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ip` text,
  `email` text,
  `senha` text,
  `status` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1060 DEFAULT CHARSET=latin1;

--
-- Definition of table `euteajudo1`.`schema_migrations`
--

DROP TABLE IF EXISTS `euteajudo1`.`schema_migrations`;
CREATE TABLE  `euteajudo1`.`schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `euteajudo1`.`schema_migrations`
--

/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
LOCK TABLES `schema_migrations` WRITE;
UNLOCK TABLES;
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;




/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
