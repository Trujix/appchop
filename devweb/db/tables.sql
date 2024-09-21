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
    apellidos TEXT NOT NULL DEFAULT '-' COMMENT 'Apellido(s) del usuario',
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


CREATE TABLE IF NOT EXISTS app_usuarios_acciones(
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'Id de registro',
    id_sistema VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de sistema',
    usuario VARCHAR(150) NOT NULL DEFAULT '-' COMMENT 'Usuario/identificador',
    accion VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Descripcion de accion usuario'
);

CREATE TABLE IF NOT EXISTS app_log_backups(
    id_sistema VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de sistema',
    id_backup VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de ultima actualización',
    usuario VARCHAR(150) NOT NULL DEFAULT '-' COMMENT 'Usuario que registra',
    fecha_creacion VARCHAR(10) NOT NULL DEFAULT '-' COMMENT 'Fecha de creacion del registro',
    fh_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora del registro'
);

CREATE TABLE IF NOT EXISTS app_cobranzas(
    tabla VARCHAR(50) NOT NULL DEFAULT '-' COMMENT 'Id de tabla local storage',
    id_sistema VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de sistema',
    id_cobranza VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de cobranza',
    tipo_cobranza VARCHAR(20) NOT NULL DEFAULT '-' COMMENT 'Tipo de cobranza Debo Me deben',
    zona VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Zona de registro de cobranza',
    nombre TEXT NOT NULL DEFAULT '-' COMMENT 'Nombre de cliente',
    cantidad FLOAT NOT NULL DEFAULT 0 COMMENT 'Monto de la nota de cobranza',
    descripcion VARCHAR(100) NOT NULL DEFAULT '-' COMMENT 'Descripcion de cobranza',
    telefono TEXT NOT NULL DEFAULT '-' COMMENT 'Telefono de cliente',
    direccion TEXT NOT NULL DEFAULT '-' COMMENT 'Direccion de cliente',
    correo TEXT NOT NULL DEFAULT '-' COMMENT 'Correo de cliente',
    fecha_registro VARCHAR(10) NOT NULL DEFAULT '-' COMMENT 'Fecha de registro de cobranza',
    fecha_vencimiento VARCHAR(10) NOT NULL DEFAULT '-' COMMENT 'Fecha de vencimiento de cobranza',
    saldo FLOAT NOT NULL DEFAULT 0 COMMENT 'Saldo restante de cobranza',
    latitud TEXT NOT NULL DEFAULT '-' COMMENT 'Longitud coordenada hubicacion',
    longitud TEXT NOT NULL DEFAULT '-' COMMENT 'Latitud coordenada hubicacion',
    ultimo_cargo FLOAT NOT NULL DEFAULT 0 COMMENT 'Monto ultimo cargo',
    fecha_ultimo_cargo VARCHAR(10) NOT NULL DEFAULT '-' COMMENT 'Fecha ultimo cargo',
    usuario_ultimo_cargo VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Usuario genera ultimo cargo',
    ultimo_abono FLOAT NOT NULL DEFAULT 0 COMMENT 'Monto ultimo abono',
    fecha_ultimo_abono VARCHAR(10) NOT NULL DEFAULT '-' COMMENT 'Fecha ultimo abono',
    usuario_ultimo_abono VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Usuario ultimo abono',
    estatus VARCHAR(20) NOT NULL DEFAULT '-' COMMENT 'Estatus de nota de cobranza',
    bloqueado VARCHAR(20) NOT NULL DEFAULT '-' COMMENT 'Estatus bloqueo de nota cobranza',
    id_cobrador VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de usuario cobrador',
    estatus_manual VARCHAR(60) NOT NULL DEFAULT '-' COMMENT 'Estatus manual'
);

CREATE TABLE IF NOT EXISTS app_cargos_abonos(
    tabla VARCHAR(50) NOT NULL DEFAULT '-' COMMENT 'Id de tabla local storage',
    id_sistema VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de sistema',
    id_cobranza VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de cobranza',
    id_movimiento VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id del movimiento',
    tipo VARCHAR(20) NOT NULL DEFAULT '-' COMMENT 'Tipo de movimiento Cargo - Abono',
    monto FLOAT NOT NULL DEFAULT 0 COMMENT 'Monto del movimiento',
    referencia VARCHAR(200) NOT NULL DEFAULT '-' COMMENT 'Referencia del movimiento',
    usuario_registro VARCHAR(150) NOT NULL DEFAULT '-' COMMENT 'Usuario que registra el movimiento',
    fecha_registro VARCHAR(10) NOT NULL DEFAULT '-' COMMENT 'Fecha de creacion del registro',
    genera VARCHAR(15) NOT NULL DEFAULT '-' COMMENT 'Tipo genera registro manual automatico'
);

CREATE TABLE IF NOT EXISTS app_notas(
    tabla VARCHAR(50) NOT NULL DEFAULT '-' COMMENT 'Id de tabla local storage',
    id_sistema VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de sistema',
    id_nota VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de nota',
    id_cobranza VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro cobranza',
    nota VARCHAR(200) NOT NULL DEFAULT '-' COMMENT 'Descripcion de la nota',
    usuario_crea VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Usuario que crea la nota',
    usuario_visto VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Usuario que visualiza nota',
    fecha_crea VARCHAR(10) NOT NULL DEFAULT '-' COMMENT 'Fecha creacion de la nota'
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

CREATE TABLE IF NOT EXISTS app_clientes(
    tabla VARCHAR(50) NOT NULL DEFAULT '-' COMMENT 'Id de tabla local storage',
    id_sistema VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de sistema',
    id_cliente VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de cliente',
    nombre TEXT NOT NULL DEFAULT '-' COMMENT 'Nombre del cliente',
    telefono TEXT NOT NULL DEFAULT '-' COMMENT 'Telefono del cliente',
    fecha_creacion VARCHAR(10) NOT NULL DEFAULT '-' COMMENT 'Fecha de creacion del registro',
    activo BIT NOT NULL DEFAULT 0 COMMENT 'Estatus del registro'
);

CREATE TABLE IF NOT EXISTS app_inventarios(
    tabla VARCHAR(50) NOT NULL DEFAULT '-' COMMENT 'Id de tabla local storage',
    id_sistema VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de sistema',
    id_articulo VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de registro de articulo',
    codigo_articulo VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Codigo clave sku de articulo',
    descripcion VARCHAR(40) NOT NULL DEFAULT '-' COMMENT 'Descripcion de articulo',
    marca VARCHAR(40) NOT NULL DEFAULT '-' COMMENT 'Marca de articulo',
    talla VARCHAR(40) NOT NULL DEFAULT '-' COMMENT 'Talla de articulo',
    precio_compra FLOAT NOT NULL DEFAULT 0 COMMENT 'Precio de compra',
    precio_venta FLOAT NOT NULL DEFAULT 0 COMMENT 'Precio de venta',
    existencia FLOAT NOT NULL DEFAULT 0 COMMENT 'Existencias del articulo',
    maximo FLOAT NOT NULL DEFAULT 0 COMMENT 'Cantidad maxima stock',
    minimo FLOAT NOT NULL DEFAULT 0 COMMENT 'Cantidad minima stock',
    fecha_cambio VARCHAR(10) NOT NULL DEFAULT '-' COMMENT 'Fecha de creacion del registro',
    usuario VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Usuario genera registro'
);

CREATE TABLE IF NOT EXISTS app_aux(
    funcion VARCHAR(150) NOT NULL DEFAULT '-' COMMENT 'Nombre funcion',
    value1 VARCHAR(400) NOT NULL DEFAULT '-' COMMENT 'Value 1',
    value2 VARCHAR(400) NOT NULL DEFAULT '-' COMMENT 'Value 2',
    value3 VARCHAR(400) NOT NULL DEFAULT '-' COMMENT 'Value 3',
    value4 VARCHAR(400) NOT NULL DEFAULT '-' COMMENT 'Value 4',
    value5 VARCHAR(400) NOT NULL DEFAULT '-' COMMENT 'Value 5',
    value6 VARCHAR(400) NOT NULL DEFAULT '-' COMMENT 'Value 6',
    value7 VARCHAR(400) NOT NULL DEFAULT '-' COMMENT 'Value 7',
    value8 VARCHAR(400) NOT NULL DEFAULT '-' COMMENT 'Value 8',
    value9 VARCHAR(400) NOT NULL DEFAULT '-' COMMENT 'Value 9',
    value10 VARCHAR(400) NOT NULL DEFAULT '-' COMMENT 'Value 10',
    fh_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora del registro'
);

/*
  String? tabla = "cargos_abonos";
  String? idUsuario;
  String? idCobranza;
  String? idMovimiento;
  String? tipo;
  double? monto;
  String? referencia;
  String? usuarioRegistro;
  String? fechaRegistro;
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

ALTER TABLE app_cobranzas ADD estatus_manual VARCHAR(60) NOT NULL DEFAULT '-' COMMENT 'Estatus manual';

INSERT INTO appchop.app_notas (tabla, id_sistema, id_nota, id_cobranza, nota, usuario_crea, usuario_visto, fecha_crea) VALUES ('notas',	'ed794927-cd27-40b6-ae3d-faa48f4a903c',	'556786d3-d4ac-4a60-934c-cab649d0339c',	'122e726e-af3f-4625-a645-ec5e8fc9d80a',	'pendiente checar si le quedaron', 'ADMINISTRADOR', '', '14-07-2024');
INSERT INTO appchop.app_notas (tabla, id_sistema, id_nota, id_cobranza, nota, usuario_crea, usuario_visto, fecha_crea) VALUES ('notas',	'ed794927-cd27-40b6-ae3d-faa48f4a903c',	'27c0c7a8-1aec-46f8-b341-5b9cfae9ecaa',	'd8668e75-ec3d-46a1-bdc3-4a620adbd2c6',	'01 de julio, hara transferencia', 'ADMINISTRADOR', '', '14-07-2024');
INSERT INTO appchop.app_notas (tabla, id_sistema, id_nota, id_cobranza, nota, usuario_crea, usuario_visto, fecha_crea) VALUES ('notas',	'ed794927-cd27-40b6-ae3d-faa48f4a903c',	'd9f73ab9-b342-4901-b490-26fc74c684d2',	'9d8f59cf-1107-4668-9598-e59231aaaefc',	'prueba',  'ADMINISTRADOR', '', '14-07-2024');
INSERT INTO appchop.app_notas (tabla, id_sistema, id_nota, id_cobranza, nota, usuario_crea, usuario_visto, fecha_crea) VALUES ('notas',	'ed794927-cd27-40b6-ae3d-faa48f4a903c',	'4bf2dc40-9468-4d00-9790-fb1ef45f6f66',	'8116065d-4f69-4790-8435-c3ac539b930c',	'transfiere  el viernes',  'ADMINISTRADOR', '', '14-07-2024');
INSERT INTO appchop.app_notas (tabla, id_sistema, id_nota, id_cobranza, nota, usuario_crea, usuario_visto, fecha_crea) VALUES ('notas',	'ed794927-cd27-40b6-ae3d-faa48f4a903c',	'cc9d3ea9-a4ca-4ada-90f5-90eb9d25e797',	'ec512acf-0765-4ad7-a171-ab95d93cc51a',	'se anoto abono de 200 del 1 de julio que le hacía falta',  'ADMINISTRADOR', '', '14-07-2024');
INSERT INTO appchop.app_notas (tabla, id_sistema, id_nota, id_cobranza, nota, usuario_crea, usuario_visto, fecha_crea) VALUES ('notas',	'ed794927-cd27-40b6-ae3d-faa48f4a903c',	'f87d166a-b961-4ce0-b9ff-353382178644',	'282251c6-20a0-4263-a3f1-5a55b8bd7c3b',	'nota prueba', 'ADMINISTRADOR', '', '14-07-2024');
INSERT INTO appchop.app_notas (tabla, id_sistema, id_nota, id_cobranza, nota, usuario_crea, usuario_visto, fecha_crea) VALUES ('notas',	'ed794927-cd27-40b6-ae3d-faa48f4a903c',	'015398aa-0f08-4a4a-9e0d-03aaedb1fc41',	'f4d95861-f44c-4897-9abc-71448ea094a4',	'nota prueba',  'ADMINISTRADOR', '', '14-07-2024');
INSERT INTO appchop.app_notas (tabla, id_sistema, id_nota, id_cobranza, nota, usuario_crea, usuario_visto, fecha_crea) VALUES ('notas',	'ed794927-cd27-40b6-ae3d-faa48f4a903c',	'6fda0d0d-7bb4-4a43-9ff9-917556759f24',	'bc15a030-2b5f-4205-a2bb-5577ed028b83',	'se liquido nota de  $109 pasado con abono de 300 y se agrego el resto $191', 'ADMINISTRADOR', '', '14-07-2024');
INSERT INTO appchop.app_notas (tabla, id_sistema, id_nota, id_cobranza, nota, usuario_crea, usuario_visto, fecha_crea) VALUES ('notas',	'ed794927-cd27-40b6-ae3d-faa48f4a903c',	'6e9992aa-a23e-4503-bf2f-a3ec81fb2374',	'd33ffd37-e60d-43c9-be57-05a936fbf209',	'mandar estado de cuenta',  'ADMINISTRADOR', '', '14-07-2024');
INSERT INTO appchop.app_notas (tabla, id_sistema, id_nota, id_cobranza, nota, usuario_crea, usuario_visto, fecha_crea) VALUES ('notas',	'ed794927-cd27-40b6-ae3d-faa48f4a903c',	'abc01e67-70dc-4646-b497-bfb37d2dd1f1',	'aca91422-9a94-4a09-8417-c8c5adb33047',	'tiene un pantalon  asu fabor',  'ADMINISTRADOR', '', '14-07-2024');
INSERT INTO appchop.app_notas (tabla, id_sistema, id_nota, id_cobranza, nota, usuario_crea, usuario_visto, fecha_crea) VALUES ('notas',	'ed794927-cd27-40b6-ae3d-faa48f4a903c',	'd03f05ef-3e0d-4bad-aeed-9dc030fe0c38',	'd336da2b-4c5d-42d6-ad42-3627daa20ea4',	'pendiente balance a su favor por defecto',  'ADMINISTRADOR', '', '14-07-2024');
INSERT INTO appchop.app_notas (tabla, id_sistema, id_nota, id_cobranza, nota, usuario_crea, usuario_visto, fecha_crea) VALUES ('notas',	'ed794927-cd27-40b6-ae3d-faa48f4a903c',	'569c7ccf-5074-4117-a9b0-65cc601a0372',	'd3818651-9696-4a4e-ae40-df73f238b812',	'nota prueba', 'ADMINISTRADOR', '', '14-07-2024');