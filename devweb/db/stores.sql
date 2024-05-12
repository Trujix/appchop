/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_VERIFICAR_AUTORIZATION;
DELIMITER $$
CREATE PROCEDURE STP_VERIFICAR_AUTORIZATION(
    IN _TOKEN VARCHAR(80)
)
BEGIN
    DECLARE _VERIFY INT DEFAULT 0;
    SET _VERIFY = (
        SELECT 
            COUNT(*) AS VERIFY
        FROM appchop.autorization WHERE 
            SHA2(token, 256) = SHA2(_TOKEN, 256)
    );
    SELECT _VERIFY AS TOKEN;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_INICIAR_SESION;
DELIMITER $$
CREATE PROCEDURE STP_INICIAR_SESION(
    IN _USUARIO VARCHAR(150), IN _PASSWORD VARCHAR(150)
)
BEGIN
    DECLARE _ID INT DEFAULT 0;
    SET _ID = (
        SELECT
            US1.id 
        FROM appchop.usuarios AS US1
        WHERE US1.usuario = _USUARIO 
            AND US1.password = MD5(_PASSWORD)
    );
    SELECT
        US1.id,
        US1.id_sistema,
        US1.usuario,
        US1.status,
        US1.id_autorization,
        US1.nombres,
        US1.apellidos,
        US1.id_firebase,
        US1.perfil,
        US1.sesion,
        US1.acepta,
        AU1.token
    FROM appchop.usuarios AS US1
        LEFT OUTER JOIN appchop.autorization AU1 ON AU1.id = US1.id_autorization
    WHERE US1.id = _ID;
END $$
DELIMITER ;

/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_ACTUALIZAR_SESION;
DELIMITER $$
CREATE PROCEDURE STP_ACTUALIZAR_SESION(
    IN _IDSISTEMA VARCHAR(120),
    IN _SESSION VARCHAR(30),
    IN _FIREBASE VARCHAR(350)
)
BEGIN
    UPDATE appchop.usuarios SET 
        sesion = _SESSION, 
        id_firebase = _FIREBASE 
    WHERE id_sistema = _IDSISTEMA;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_ACEPTA_ACTUALIZAR;
DELIMITER $$
CREATE PROCEDURE STP_ACEPTA_ACTUALIZAR(
    IN _IDSISTEMA VARCHAR(120), IN _ACEPTA BIT
)
BEGIN
    UPDATE appchop.usuarios SET 
        acepta = _ACEPTA
    WHERE id_sistema = _IDSISTEMA;
END $$
DELIMITER ;

/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_VERIFICAR_ESTATUS_USUARIO;
DELIMITER $$
CREATE PROCEDURE STP_VERIFICAR_ESTATUS_USUARIO(
    IN _IDSISTEMA VARCHAR(120), IN _PERFIL VARCHAR(150)
)
BEGIN
    SELECT 
        status 
    FROM appchop.usuarios 
    WHERE id_sistema = _IDSISTEMA 
        AND perfil = _PERFIL;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_VERIFICAR_COBRADOR;
DELIMITER $$
CREATE PROCEDURE STP_VERIFICAR_COBRADOR(
    IN _IDSISTEMA VARCHAR(120), IN _USUARIO VARCHAR(150)
)
BEGIN
    DECLARE _VERIFY INT DEFAULT 0;
    SET _VERIFY = (
        SELECT 
            COUNT(*) AS VERIFY
        FROM appchop.usuarios WHERE 
            id_sistema = _IDSISTEMA 
            AND usuario = _USUARIO 
            AND perfil = 'COBRADOR'
    );
    SELECT _VERIFY AS EXISTE;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_ALTA_COBRADOR;
DELIMITER $$
CREATE PROCEDURE STP_ALTA_COBRADOR(
    IN _IDSISTEMA VARCHAR(120), IN _USUARIO VARCHAR(150), IN _PASSWORD VARCHAR(150),
    IN _NOMBRES VARCHAR(150), IN _APELLIDOS VARCHAR(150) 
)
BEGIN
    DECLARE _IDAUTORIZACION INT DEFAULT 0;
    SET _IDAUTORIZACION = (
        SELECT 
            id_autorization 
        FROM appchop.usuarios WHERE
            id_sistema = _IDSISTEMA
            AND perfil = 'ADMINISTRADOR' 
        LIMIT 1
    );
    IF _IDAUTORIZACION > 0 THEN
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
            _IDSISTEMA,
            _USUARIO,
            MD5(_PASSWORD),
            'ACTIVO',
            _IDAUTORIZACION,
            _NOMBRES,
            _APELLIDOS,
            'COBRADOR'
        );
    ELSE
        SELECT 0;
    END IF;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_ACTUALIZAR_PASSWORD_COBRADOR;
DELIMITER $$
CREATE PROCEDURE STP_ACTUALIZAR_PASSWORD_COBRADOR(
    IN _IDSISTEMA VARCHAR(120),
    IN _USUARIO VARCHAR(150),
    IN _PASSWORD VARCHAR(150)
)
BEGIN
    UPDATE appchop.usuarios SET 
        password = MD5(_PASSWORD) 
    WHERE id_sistema = _IDSISTEMA
        AND usuario = _USUARIO;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_OBTENER_COBRADOR_INFO;
DELIMITER $$
CREATE PROCEDURE STP_OBTENER_COBRADOR_INFO(
    IN _IDSISTEMA VARCHAR(120), IN _USUARIO VARCHAR(150)
)
BEGIN
    SELECT
        US1.id,
        US1.id_sistema,
        US1.usuario,
        US1.status,
        US1.nombres,
        US1.apellidos,
        US1.id_firebase
    FROM appchop.usuarios AS US1
        WHERE US1.id_sistema = _IDSISTEMA
            AND US1.usuario = _USUARIO;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_ACTUALIZAR_ESTATUS_COBRADOR;
DELIMITER $$
CREATE PROCEDURE STP_ACTUALIZAR_ESTATUS_COBRADOR(
    IN _IDSISTEMA VARCHAR(120),
    IN _USUARIO VARCHAR(150),
    IN _STATUS VARCHAR(15)
)
BEGIN
    UPDATE appchop.usuarios SET 
        status = _STATUS 
    WHERE id_sistema = _IDSISTEMA
        AND usuario = _USUARIO;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_USUARIOS_GET;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_USUARIOS_GET(
    IN _IDSISTEMA VARCHAR(120)
)
BEGIN
    SELECT 
        id_sistema AS idUsuario,
        usuario,
        (
            CASE
                WHEN status = 'ACTIVO' THEN 1
                ELSE 0
            END
        ) AS estatus,
        nombres,
        apellidos
    FROM appchop.usuarios
        WHERE id_sistema = _IDSISTEMA
            AND perfil = 'COBRADOR';
END $$
DELIMITER ;



/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_OBTENER_CONFIGURACION_USUARIO;
DELIMITER $$
CREATE PROCEDURE STP_OBTENER_CONFIGURACION_USUARIO(
    IN _IDSISTEMA VARCHAR(120)
)
BEGIN
    SELECT
        US1.id,
        US1.id_sistema AS idUsuario,
        US1.porcentaje_bonificacion AS porcentajeBonificacion,
        US1.porcentaje_moratorio AS porcentajeMoratorio 
    FROM appchop.configuracion AS US1
        WHERE US1.id_sistema = _IDSISTEMA;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_ZONAS_GET;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_ZONAS_GET(
    IN _IDSISTEMA VARCHAR(120)
)
BEGIN
    SELECT 
        id_sistema AS idUsuario,
        id_zona AS idZona,
        value_zona AS valueZona,
        label_zona AS labelZona,
        fecha_creacion AS fechaCreacion,
        activo AS activobit
    FROM appchop.app_zonas
        WHERE id_sistema = _IDSISTEMA;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_ZONAS_COBRADOR_GET;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_ZONAS_COBRADOR_GET(
    IN _IDSISTEMA VARCHAR(120), in _USUARIO VARCHAR(150)
)
BEGIN
    SELECT 
        id_sistema AS idUsuario,
        id_zona AS idZona,
        value_zona AS valueZona,
        label_zona AS labelZona,
        fecha_creacion AS fechaCreacion,
        activo AS activobit
    FROM appchop.app_zonas 
        WHERE value_zona = (
            SELECT 
                id_zona 
            FROM appchop.app_zonas_usuarios 
                WHERE usuario = _USUARIO 
                    AND id_sistema = _IDSISTEMA
            LIMIT 1
        );
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_ZONAS_DELETE;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_ZONAS_DELETE(
    IN _IDSISTEMA VARCHAR(120)
)
BEGIN
    DELETE FROM 
        appchop.app_zonas
    WHERE id_sistema = _IDSISTEMA;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_ZONAS_INSERT;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_ZONAS_INSERT(
    IN _TABLA VARCHAR(50), IN _IDSISTEMA VARCHAR(120), 
    IN _IDZONA VARCHAR(120), IN _VALUEZONA VARCHAR(120), 
    IN _LABELZONA VARCHAR(40), IN _FECHACREACION VARCHAR(10), 
    IN _ACTIVO BIT
)
BEGIN
    INSERT INTO appchop.app_zonas (
        tabla, 
        id_sistema, 
        id_zona, 
        value_zona, 
        label_zona, 
        fecha_creacion, 
        activo
    ) VALUES (
        _TABLA, 
        _IDSISTEMA, 
        _IDZONA, 
        _VALUEZONA, 
        _LABELZONA, 
        _FECHACREACION, 
        _ACTIVO
    );
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_ZONASUSUARIOS_GET;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_ZONASUSUARIOS_GET(
    IN _IDSISTEMA VARCHAR(120)
)
BEGIN
    SELECT 
        id_sistema AS idUsuario,
        id_zona AS idZona,
        usuario 
    FROM appchop.app_zonas_usuarios
        WHERE id_sistema = _IDSISTEMA;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_ZONASUSUARIOS_DELETE;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_ZONASUSUARIOS_DELETE(
    IN _IDSISTEMA VARCHAR(120)
)
BEGIN
    DELETE FROM 
        appchop.app_zonas_usuarios
    WHERE id_sistema = _IDSISTEMA;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_ZONASUSUARIOS_INSERT;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_ZONASUSUARIOS_INSERT(
    IN _TABLA VARCHAR(50), IN _IDSISTEMA VARCHAR(120), 
    IN _IDZONA VARCHAR(120), IN _USUARIO VARCHAR(150)
)
BEGIN
    INSERT INTO appchop.app_zonas_usuarios (
        tabla, 
        id_sistema, 
        id_zona, 
        usuario
    ) VALUES (
        _TABLA, 
        _IDSISTEMA, 
        _IDZONA, 
        _USUARIO
    );
END $$
DELIMITER ;