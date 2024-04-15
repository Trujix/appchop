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