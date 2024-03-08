
/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_ACTUALIZAR_SESION;
DELIMITER $$
CREATE PROCEDURE STP_ACTUALIZAR_SESION(
    IN _ID int(11),  
    IN _SESSION VARCHAR(30)
)
BEGIN
    DECLARE _ID INT DEFAULT 0;
    SET _ID = (
        SELECT
            US1.id 
        FROM appchop.usuarios AS US1
        WHERE US1.id = _ID 
    );
    UPDATE appchop.usuarios SET 
        sesion = _SESSION
    WHERE id = _ID;
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
        US1.sesion
    FROM appchop.usuarios AS US1
    WHERE US1.id = _ID;
END $$
DELIMITER ;