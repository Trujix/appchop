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
    sesion VARCHAR(30) NOT NULL DEFAULT 'NONE' COMMENT 'Indica si hay una sesion activa',
    acepta BIT NOT NULL DEFAULT 0 COMMENT 'Confirma si el usuario acepta Terminos y Condiciones',
    fh_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora del registro'
);

CREATE TABLE IF NOT EXISTS configuracion(
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'Id de registro',
    id_sistema VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de sistema',
    porcentaje_bonificacion FLOAT NOT NULL DEFAULT 0 COMMENT 'Valor del porcentaje de bonificacion',
    porcentaje_moratorio FLOAT NOT NULL DEFAULT 0 COMMENT 'Valor del porcentaje del interes moratorio'
);

CREATE TABLE IF NOT EXISTS app_zonas(
    tabla VARCHAR(50) NOT NULL DEFAULT '-' COMMENT 'Id de tabla local storage',
    id_sistema VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de sistema',
    id_zona VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de zona',
    value_zona VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id mascara de valor zona',
    label_zona VARCHAR(40) NOT NULL DEFAULT '-' COMMENT 'Etiqueta mascara de valor zona',
    fecha_creacion VARCHAR(10) NOT NULL DEFAULT '-' COMMENT 'Fecha de creacion del registro',
    activo BIT NOT NULL DEFAULT 0 COMMENT 'Estatus del registro'
);

CREATE TABLE IF NOT EXISTS app_zonas_usuarios(
    tabla VARCHAR(50) NOT NULL DEFAULT '-' COMMENT 'Id de tabla local storage',
    id_sistema VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de sistema',
    id_zona VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de zona vinculada al usuario',
    usuario VARCHAR(150) NOT NULL DEFAULT '-' COMMENT 'Usuario al que se vincula la zona'
);

/*
"tabla":"zonas",
"idUsuario":"b0339cf5-e46e-4179-9ea9-3772e4aaf26b",
"idZona":"61d6e1d2-754b-4b77-b8f0-a563951fe097",
"valueZona":"88bbe1aa-cbe7-41d5-9654-c2eefef8ae74",
"labelZona":"Prueba",
"fechaCreacion":"08-05-2024",
"activo":true
*/
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
    'b0339cf5-e46e-4179-9ea9-3772e4aaf26b',
    'manuel@mail.com',
    MD5('12345'),
    'ACTIVO',
    2,
    'Manuel',
    'Trujillo',
    'ADMINISTRADOR'
);

INSERT INTO configuracion (
    id_sistema,
    porcentaje_bonificacion,
    porcentaje_moratorio
) VALUES (
    'b0339cf5-e46e-4179-9ea9-3772e4aaf26b',
    5,
    2
);
*/