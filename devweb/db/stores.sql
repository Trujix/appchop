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
        AU1.token
    FROM appchop.usuarios AS US1
        LEFT OUTER JOIN appchop.autorization AU1 ON Au1.id = US1.id_autorization
    WHERE US1.usuario = _USUARIO 
        AND US1.password = MD5(_PASSWORD);
END $$
DELIMITER ;