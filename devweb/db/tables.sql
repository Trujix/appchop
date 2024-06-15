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
    id_cobrador VARCHAR(120) NOT NULL DEFAULT '-' COMMENT 'Id de usuario cobrador'
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
    nota VARCHAR(200) NOT NULL DEFAULT '-' COMMENT 'Descripcion de la nota'
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