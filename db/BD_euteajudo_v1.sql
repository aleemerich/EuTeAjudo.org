
CREATE TABLE `amigo_bloqueados` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `amigo_id` int(11) DEFAULT NULL,
  `amigo_id_bloq` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `motivo` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=latin1;


CREATE TABLE `amigo_conversa_controles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `amigo_id` int(11) DEFAULT NULL,
  `conversa_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `flagNovidade` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=latin1;



CREATE TABLE `amigo_denuncias` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `amigo_id` int(11) DEFAULT NULL,
  `amigo_id_denunciado` int(11) DEFAULT NULL,
  `dialogo_id` int(11) DEFAULT NULL,
  `texto` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=latin1;

CREATE TABLE `amigos` (
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
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=latin1;



CREATE TABLE `conversas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `assunto` varchar(255) DEFAULT NULL,
  `amigo_id` int(11) DEFAULT NULL,
  `flagColaboracaoUnica` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=latin1;



CREATE TABLE `dialogos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `conversa_id` int(11) DEFAULT NULL,
  `amigo_id` int(11) DEFAULT NULL,
  `texto` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=141 DEFAULT CHARSET=latin1;


CREATE TABLE `log_acessos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ip` text,
  `email` text,
  `senha` text,
  `status` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=223 DEFAULT CHARSET=latin1;


CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

