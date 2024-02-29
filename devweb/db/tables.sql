CREATE DATABASE IF NOT EXISTS appchop;

USE appchop;

CREATE TABLE IF NOT EXISTS autorization(
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'Id de registro',
    token VARCHAR(80) NOT NULL DEFAULT '-' COMMENT 'Token de acceso y seguridad',
    fh_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora del registro'
);

CREATE TABLE IF NOT EXISTS usuarios(
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'Id de registro',
    id_sistema VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de sistema',
    usuario VARCHAR(150) NOT NULL DEFAULT '-' COMMENT 'Usuario/identificador',
    password VARCHAR(150) NOT NULL DEFAULT '-' COMMENT 'Password de acceso',
    status VARCHAR(15) NOT NULL DEFAULT '-' COMMENT 'Estatus del usuario',
    id_autorization INT NOT NULL COMMENT 'Id Autorizacion',
    nombres VARCHAR(150) NOT NULL DEFAULT '-' COMMENT 'Nombre(s) del usuario',
    apellidos VARCHAR(150) NOT NULL DEFAULT '-' COMMENT 'Apellido(s) del usuario',
    perfil VARCHAR(150) NOT NULL DEFAULT '-' COMMENT 'Perfil de usuario',
    id_firebase VARCHAR(350) NOT NULL DEFAULT '-' COMMENT 'Id del sistema de Notificaciones Firebase',
    fh_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora del registro'
);

/*
INSERT INTO autorization (
    token
) VALUES (
    MD5('$VALOR$')
);

INSERT INTO usuarios (
    id_sistema,
    usuario,
    password,
    status,
    id_autorization,
    nombres,
    apellidos,
    perfil
) VALUES (
    'abc-ABC-1234',
    'manuel@mail.com',
    MD5('12345'),
    'ACTIVO',
    2,
    'Manuel',
    'Trujillo',
    'ADMINISTRADOR'
);
*/