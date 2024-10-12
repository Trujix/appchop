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
DROP PROCEDURE IF EXISTS STP_VERIFICAR_USUARIO;
DELIMITER $$
CREATE PROCEDURE STP_VERIFICAR_USUARIO(
    IN _USUARIO VARCHAR(150)
)
BEGIN
    DECLARE _VERIFY INT DEFAULT 0;
    SET _VERIFY = (
        SELECT 
            COUNT(*) AS VERIFY
        FROM appchop.usuarios WHERE 
            usuario = _USUARIO
    );
    SELECT _VERIFY AS EXISTE;
END $$
DELIMITER ;



/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_RECUPERACION_USUARIO_PASSWORD;
DELIMITER $$
CREATE PROCEDURE STP_RECUPERACION_USUARIO_PASSWORD(
    IN _USUARIO VARCHAR(150), IN _PASSWORD VARCHAR(150), IN _STATUS VARCHAR(15)
)
BEGIN
    UPDATE appchop.usuarios SET
        password = MD5(_PASSWORD),
        status = _STATUS
    WHERE 
        usuario = _USUARIO;
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
        AU1.token,
        IFNULL(
            (
                SELECT 
                    UA1.accion 
                FROM appchop.app_usuarios_acciones UA1
                    WHERE UA1.id_sistema = US1.id_sistema
                        AND UA1.usuario = _USUARIO
                LIMIT 1
            ),
            '-'
        ) AS accion
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
    IN _USUARIO VARCHAR(150),
    IN _SESSION VARCHAR(30),
    IN _FIREBASE VARCHAR(350)
)
BEGIN
    UPDATE appchop.usuarios SET 
        sesion = _SESSION, 
        id_firebase = _FIREBASE 
    WHERE id_sistema = _IDSISTEMA
        AND usuario = _USUARIO;
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
    IN _IDSISTEMA VARCHAR(120), IN _USUARIO VARCHAR(150)
)
BEGIN
    SELECT 
        status 
    FROM appchop.usuarios 
    WHERE id_sistema = _IDSISTEMA 
        AND usuario = _USUARIO;
END $$
DELIMITER ;



/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_VERIFICAR_PERFIL_USUARIO;
DELIMITER $$
CREATE PROCEDURE STP_VERIFICAR_PERFIL_USUARIO(
    IN _IDSISTEMA VARCHAR(120), IN _USUARIO VARCHAR(150)
)
BEGIN
    SELECT 
        perfil 
    FROM appchop.usuarios 
    WHERE id_sistema = _IDSISTEMA 
        AND usuario = _USUARIO;
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
            CONVERT(_NOMBRES USING UTF8),
            CONVERT(_APELLIDOS USING UTF8),
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
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_ACCION_GET;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_ACCION_GET(
    IN _IDSISTEMA VARCHAR(120), IN _USUARIO VARCHAR(150)
)
BEGIN
    SELECT
        IFNULL(accion, '-') AS accion
    FROM appchop.app_usuarios_acciones
        WHERE id_sistema = _IDSISTEMA
            AND usuario = _USUARIO;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_ACCION_INSERT;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_ACCION_INSERT(
    IN _IDSISTEMA VARCHAR(120), IN _USUARIO VARCHAR(150),
    IN _ACCION VARCHAR(120)
)
BEGIN
    INSERT INTO appchop.app_usuarios_acciones (
        id_sistema, 
        usuario, 
        accion
    ) VALUES (
        _IDSISTEMA, 
        _USUARIO, 
        _ACCION
    );
END $$
DELIMITER ;



/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_ACCION_DELETE;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_ACCION_DELETE(
    IN _IDSISTEMA VARCHAR(120), IN _USUARIO VARCHAR(150)
)
BEGIN
    DELETE FROM appchop.app_usuarios_acciones
        WHERE id_sistema = _IDSISTEMA
            AND usuario = _USUARIO;
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
DROP PROCEDURE IF EXISTS STP_APP_VERIFICAR_BACKUP;
DELIMITER $$
CREATE PROCEDURE STP_APP_VERIFICAR_BACKUP(
    IN _IDSISTEMA VARCHAR(120)
)
BEGIN
    SELECT 
        id_sistema AS idUsuario,
        id_backup AS idBackup,
        usuario,
        fecha_creacion AS fechaCreacion 
    FROM appchop.app_log_backups
        WHERE id_sistema = _IDSISTEMA;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_LOGBACKUP_PROCESS;
DELIMITER $$
CREATE PROCEDURE STP_APP_LOGBACKUP_PROCESS(
    IN _IDSISTEMA VARCHAR(120), IN _IDBACKUP VARCHAR(120),
    IN _USUARIO VARCHAR(150), IN _FECHACREACION VARCHAR(10)
)
BEGIN
    DECLARE _VERIFY INT DEFAULT 0;
    SET _VERIFY = (
        SELECT 
            COUNT(*) AS VERIFY
        FROM appchop.app_log_backups 
            WHERE id_sistema = _IDSISTEMA
    );
    IF _VERIFY = 0 THEN
        INSERT INTO appchop.app_log_backups (
            id_sistema,
            id_backup,
            usuario,
            fecha_creacion
        ) VALUES (
            _IDSISTEMA,
            _IDBACKUP,
            _USUARIO,
            _FECHACREACION
        );
    ELSE
        UPDATE appchop.app_log_backups SET
            id_backup = _IDBACKUP,
            usuario = _USUARIO,
            fecha_creacion = _FECHACREACION,
            fh_registro = CURRENT_TIMESTAMP
        WHERE id_sistema = _IDSISTEMA;
    END IF;
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
        CONVERT(_LABELZONA USING UTF8), 
        _FECHACREACION, 
        _ACTIVO
    );
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_ZONAS_COBRADOR_GET;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_ZONAS_COBRADOR_GET(
    IN _IDSISTEMA VARCHAR(120), IN _USUARIO VARCHAR(150)
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


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_ZONASUSUARIOS_VERIFY;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_ZONASUSUARIOS_VERIFY(
    IN _IDSISTEMA VARCHAR(120), IN _USUARIO VARCHAR(150)
)
BEGIN
    SELECT 
        COUNT(*) AS VERIFY
    FROM appchop.app_zonas_usuarios
        WHERE id_sistema = _IDSISTEMA
            AND usuario = _USUARIO;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_COBRANZAS_PROCESS;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_COBRANZAS_PROCESS(
    IN _TABLA VARCHAR(50), IN _IDSISTEMA VARCHAR(120), IN _IDCOBRANZA VARCHAR(120), 
    IN _TIPOCOBRANZA VARCHAR(20), IN _ZONA VARCHAR(120), IN _NOMBRE TEXT, 
    IN _CANTIDAD FLOAT, IN _DESCRIPCION VARCHAR(100), IN _TELEFONO TEXT, 
    IN _DIRECCION TEXT, IN _CORREO TEXT, IN _FECHAREGISTRO VARCHAR(10), 
    IN _FECHAVENCIMIENTO VARCHAR(10), IN _SALDO FLOAT, IN _LATITUD TEXT, IN _LONGITUD TEXT, 
    IN _ULTIMOCARGO FLOAT, IN _FECHAULTIMOCARGO VARCHAR(10), IN _USUARIOULTIMOCARGO VARCHAR(120), 
    IN _ULTIMOABONO FLOAT, IN _FECHAULTIMOABONO VARCHAR(10), IN _USUARIOULTIMOABONO VARCHAR(120), 
    IN _ESTATUS VARCHAR(20), IN _BLOQUEADO VARCHAR(20), IN _IDCOBRADOR VARCHAR(120), 
    IN _ESTATUSMANUAL VARCHAR(120), IN _ENCRYPTKEY VARCHAR(30), IN _USUARIOENVIA VARCHAR(150)
)
BEGIN
    DECLARE _VERIFY INT DEFAULT 0;
    DECLARE _BLOQUEO INT DEFAULT 0;
    DECLARE _ESBLOQUEO VARCHAR(20) DEFAULT 'SI';
    SET _VERIFY = (
        SELECT 
            COUNT(*) AS VERIFY
        FROM appchop.app_cobranzas WHERE 
            id_sistema = _IDSISTEMA 
            AND id_cobranza = _IDCOBRANZA
    );
    IF _VERIFY = 0 THEN
        INSERT INTO appchop.app_cobranzas (
            tabla, 
            id_sistema, 
            id_cobranza, 
            tipo_cobranza, 
            zona, 
            nombre, 
            cantidad, 
            descripcion, 
            telefono, 
            direccion, 
            correo, 
            fecha_registro, 
            fecha_vencimiento, 
            saldo, 
            latitud, 
            longitud, 
            ultimo_cargo, 
            fecha_ultimo_cargo, 
            usuario_ultimo_cargo, 
            ultimo_abono, 
            fecha_ultimo_abono, 
            usuario_ultimo_abono, 
            estatus, 
            bloqueado, 
            id_cobrador,
            estatus_manual
        ) VALUES (
            _TABLA,
            _IDSISTEMA,
            _IDCOBRANZA,
            _TIPOCOBRANZA,
            _ZONA,
            AES_ENCRYPT(CONVERT(_NOMBRE USING UTF8), _ENCRYPTKEY),
            _CANTIDAD,
            CONVERT(_DESCRIPCION USING UTF8),
            AES_ENCRYPT(_TELEFONO, _ENCRYPTKEY),
            AES_ENCRYPT(CONVERT(_DIRECCION USING UTF8), _ENCRYPTKEY),
            AES_ENCRYPT(CONVERT(_CORREO USING UTF8), _ENCRYPTKEY),
            _FECHAREGISTRO,
            _FECHAVENCIMIENTO,
            _SALDO,
            AES_ENCRYPT(_LATITUD, _ENCRYPTKEY),
            AES_ENCRYPT(_LONGITUD, _ENCRYPTKEY),
            _ULTIMOCARGO,
            _FECHAULTIMOCARGO,
            _USUARIOULTIMOCARGO,
            _ULTIMOABONO,
            _FECHAULTIMOABONO,
            _USUARIOULTIMOABONO,
            _ESTATUS,
            _BLOQUEADO,
            _IDCOBRADOR,
            _ESTATUSMANUAL
        );
    ELSE
        IF _USUARIOENVIA = 'ADMINISTRADOR' THEN
            SET _ESBLOQUEO = 'SI';
        ELSE
            SET _ESBLOQUEO = 'NO';
        END IF;
        SET _BLOQUEO = (
            SELECT COUNT(*) AS BLOQUEO 
            FROM appchop.app_cobranzas
                WHERE id_sistema = _IDSISTEMA 
                AND id_cobranza = _IDCOBRANZA
                AND bloqueado = _ESBLOQUEO
        );
        IF _BLOQUEO = 0 THEN
            UPDATE appchop.app_cobranzas SET            
                tipo_cobranza = _TIPOCOBRANZA,
                zona = _ZONA,
                nombre = AES_ENCRYPT(CONVERT(_NOMBRE USING UTF8), _ENCRYPTKEY),
                cantidad = _CANTIDAD,
                descripcion = CONVERT(_DESCRIPCION USING UTF8),
                telefono = AES_ENCRYPT(_TELEFONO, _ENCRYPTKEY),
                direccion = AES_ENCRYPT(CONVERT(_DIRECCION USING UTF8), _ENCRYPTKEY),
                correo = AES_ENCRYPT(CONVERT(_CORREO USING UTF8), _ENCRYPTKEY),
                fecha_registro = _FECHAREGISTRO,
                fecha_vencimiento = _FECHAVENCIMIENTO,
                saldo = _SALDO,
                latitud = AES_ENCRYPT(_LATITUD, _ENCRYPTKEY),
                longitud = AES_ENCRYPT(_LONGITUD, _ENCRYPTKEY),
                ultimo_cargo = _ULTIMOCARGO,
                fecha_ultimo_cargo = _FECHAULTIMOCARGO,
                usuario_ultimo_cargo = _USUARIOULTIMOCARGO,
                ultimo_abono = _ULTIMOABONO,
                fecha_ultimo_abono = _FECHAULTIMOABONO,
                usuario_ultimo_abono = _USUARIOULTIMOABONO,
                estatus = _ESTATUS,
                bloqueado = _BLOQUEADO,
                id_cobrador = _IDCOBRADOR,
                estatus_manual = _ESTATUSMANUAL
            WHERE 
                id_sistema = _IDSISTEMA 
                AND id_cobranza = _IDCOBRANZA;
        ELSE
            SELECT _BLOQUEO AS BLOQUEO;
        END IF;
        
    END IF;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_COBRANZAS_UNLOCK;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_COBRANZAS_UNLOCK(
    IN _IDSISTEMA VARCHAR(120), IN _IDCOBRANZA VARCHAR(120), IN _BLOQUEADO VARCHAR(20)
)
BEGIN
    UPDATE appchop.app_cobranzas SET            
        bloqueado = _BLOQUEADO
    WHERE 
        id_sistema = _IDSISTEMA 
            AND id_cobranza = _IDCOBRANZA;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_COBRANZAS_ADMINISTRADOR_GET;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_COBRANZAS_ADMINISTRADOR_GET(
    IN _IDSISTEMA VARCHAR(120), IN _ENCRYPTKEY VARCHAR(30)
)
BEGIN
    SELECT 
        tabla AS tabla,
        id_sistema AS idUsuario,
        id_cobranza AS idCobranza,
        tipo_cobranza AS tipoCobranza,
        zona AS zona,
        CAST(AES_DECRYPT(nombre, _ENCRYPTKEY) AS CHAR) AS nombre,
        cantidad AS cantidad,
        descripcion AS descripcion,
        CAST(AES_DECRYPT(telefono, _ENCRYPTKEY) AS CHAR) AS telefono,
        CAST(AES_DECRYPT(direccion, _ENCRYPTKEY) AS CHAR) AS direccion,
        CAST(AES_DECRYPT(correo, _ENCRYPTKEY) AS CHAR) AS correo,
        fecha_registro AS fechaRegistro,
        fecha_vencimiento AS fechaVencimiento,
        saldo AS saldo,
        CAST(AES_DECRYPT(latitud, _ENCRYPTKEY) AS CHAR) AS latitud,
        CAST(AES_DECRYPT(longitud, _ENCRYPTKEY) AS CHAR) AS longitud,
        ultimo_cargo AS ultimoCargo,
        fecha_ultimo_cargo AS fechaUltimoCargo,
        usuario_ultimo_cargo AS usuarioUltimoCargo,
        ultimo_abono AS ultimoAbono,
        fecha_ultimo_abono AS fechaUltimoAbono,
        usuario_ultimo_abono AS usuarioUltimoAbono,
        estatus AS estatus,
        bloqueado AS bloqueado,
        id_cobrador AS idCobrador,
        estatus_manual AS estatusManual
    FROM appchop.app_cobranzas
        WHERE id_sistema = _IDSISTEMA;
END $$
DELIMITER ;



/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_COBRANZAS_COBRADOR_GET;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_COBRANZAS_COBRADOR_GET(
    IN _IDSISTEMA VARCHAR(120), IN _ENCRYPTKEY VARCHAR(30), IN _USUARIO VARCHAR(150)
)
BEGIN
    SELECT 
        COB1.tabla AS tabla,
        COB1.id_sistema AS idUsuario,
        COB1.id_cobranza AS idCobranza,
        COB1.tipo_cobranza AS tipoCobranza,
        COB1.zona AS zona,
        CAST(AES_DECRYPT(COB1.nombre, _ENCRYPTKEY) AS CHAR) AS nombre,
        COB1.cantidad AS cantidad,
        COB1.descripcion AS descripcion,
        CAST(AES_DECRYPT(COB1.telefono, _ENCRYPTKEY) AS CHAR) AS telefono,
        CAST(AES_DECRYPT(COB1.direccion, _ENCRYPTKEY) AS CHAR) AS direccion,
        CAST(AES_DECRYPT(COB1.correo, _ENCRYPTKEY) AS CHAR) AS correo,
        COB1.fecha_registro AS fechaRegistro,
        COB1.fecha_vencimiento AS fechaVencimiento,
        COB1.saldo AS saldo,
        CAST(AES_DECRYPT(COB1.latitud, _ENCRYPTKEY) AS CHAR) AS latitud,
        CAST(AES_DECRYPT(COB1.longitud, _ENCRYPTKEY) AS CHAR) AS longitud,
        COB1.ultimo_cargo AS ultimoCargo,
        COB1.fecha_ultimo_cargo AS fechaUltimoCargo,
        COB1.usuario_ultimo_cargo AS usuarioUltimoCargo,
        COB1.ultimo_abono AS ultimoAbono,
        COB1.fecha_ultimo_abono AS fechaUltimoAbono,
        COB1.usuario_ultimo_abono AS usuarioUltimoAbono,
        COB1.estatus AS estatus,
        COB1.bloqueado AS bloqueado,
        _USUARIO AS idCobrador,
        COB1.estatus_manual AS estatusManual
    FROM appchop.app_cobranzas COB1
    LEFT OUTER JOIN appchop.app_zonas_usuarios ZU1 ON COB1.zona = ZU1.id_zona
        WHERE COB1.id_sistema = _IDSISTEMA
			AND ZU1.usuario = _USUARIO;
END $$
DELIMITER ;



/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_CARGOSABONOS_DELETE;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_CARGOSABONOS_DELETE(
    IN _IDSISTEMA VARCHAR(120), IN _IDCOBRANZA VARCHAR(120), IN _IDMOVIMIENTO VARCHAR(120)
)
BEGIN
    DECLARE _VERIFY INT DEFAULT 0;
    SET _VERIFY = (
        SELECT 
            COUNT(*) AS VERIFY
        FROM appchop.app_cargos_abonos WHERE 
            id_sistema = _IDSISTEMA 
            AND id_cobranza = _IDCOBRANZA 
            AND id_movimiento = _IDMOVIMIENTO
    );
    IF _VERIFY > 0 THEN
        DELETE FROM appchop.app_cargos_abonos 
            WHERE id_sistema = _IDSISTEMA 
                AND id_cobranza = _IDCOBRANZA 
                AND id_movimiento = _IDMOVIMIENTO;
    ELSE
        SET _VERIFY = 1;
        SELECT _VERIFY FROM appchop.app_cargos_abonos;
    END IF;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_CARGOSABONOS_INSERT;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_CARGOSABONOS_INSERT(
    IN _TABLA VARCHAR(50), IN _IDSISTEMA VARCHAR(120), IN _IDCOBRANZA VARCHAR(120), 
    IN _IDMOVIMIENTO VARCHAR(120), IN _TIPO VARCHAR(20), IN _MONTO FLOAT, 
    IN _REFERENCIA VARCHAR(200), IN _USUARIOREGISTRO VARCHAR(150), 
    IN _FECHAREGISTRO VARCHAR(10), IN _GENERA VARCHAR(15)
)
BEGIN
    DECLARE _VERIFY INT DEFAULT 0;
    SET _VERIFY = (
        SELECT 
            COUNT(*) AS VERIFY
        FROM appchop.app_cargos_abonos WHERE 
            id_sistema = _IDSISTEMA 
            AND id_cobranza = _IDCOBRANZA
            AND id_movimiento = _IDMOVIMIENTO
    );
    IF _VERIFY = 0 THEN
        INSERT INTO appchop.app_cargos_abonos (
            tabla,
            id_sistema, 
            id_cobranza, 
            id_movimiento, 
            tipo, 
            monto, 
            referencia, 
            usuario_registro, 
            fecha_registro,
            genera
        ) VALUES (
            _TABLA, 
            _IDSISTEMA, 
            _IDCOBRANZA, 
            _IDMOVIMIENTO, 
            _TIPO, 
            _MONTO, 
            CONVERT(_REFERENCIA USING UTF8), 
            _USUARIOREGISTRO, 
            _FECHAREGISTRO,
            _GENERA
        );
    ELSE
        SELECT _VERIFY FROM appchop.app_cargos_abonos;
    END IF;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_CARGOSABONOS_ADMINISTRADOR_GET;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_CARGOSABONOS_ADMINISTRADOR_GET(
    IN _IDSISTEMA VARCHAR(120)
)
BEGIN
    SELECT
        CA1.tabla AS tabla,
        CA1.id_sistema AS idUsuario,
        CA1.id_cobranza AS idCobranza,
        CA1.id_movimiento AS idMovimiento,
        CA1.tipo AS tipo,
        CA1.monto AS monto,
        CA1.referencia AS referencia,
        CA1.usuario_registro AS usuarioRegistro,
        CA1.fecha_registro AS fechaRegistro,
        CA1.genera
    FROM appchop.app_cargos_abonos CA1
        WHERE CA1.id_sistema =  _IDSISTEMA;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_CARGOSABONOS_COBRADOR_GET;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_CARGOSABONOS_COBRADOR_GET(
    IN _IDSISTEMA VARCHAR(120), IN _USUARIO VARCHAR(150)
)
BEGIN
    SELECT
        CA1.tabla AS tabla,
        CA1.id_sistema AS idUsuario,
        CA1.id_cobranza AS idCobranza,
        CA1.id_movimiento AS idMovimiento,
        CA1.tipo AS tipo,
        CA1.monto AS monto,
        CA1.referencia AS referencia,
        CA1.usuario_registro AS usuarioRegistro,
        CA1.fecha_registro AS fechaRegistro,
        CA1.genera
    FROM appchop.app_cargos_abonos CA1
        LEFT OUTER JOIN appchop.app_cobranzas C1 ON CA1.id_cobranza = C1.id_cobranza
        LEFT OUTER JOIN appchop.app_zonas_usuarios ZU1 ON C1.zona = ZU1.id_zona
    WHERE CA1.id_sistema =  _IDSISTEMA
        AND ZU1.usuario = _USUARIO;
END $$
DELIMITER ;



/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_NOTAS_ADMINISTRADOR_GET;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_NOTAS_ADMINISTRADOR_GET(
    IN _IDSISTEMA VARCHAR(120)
)
BEGIN
    SELECT
        tabla AS tabla,
        id_sistema AS idUsuario,
        id_nota AS idNota,
        id_cobranza AS idCobranza,
        nota,
        usuario_crea AS usuarioCrea,
        usuario_visto AS usuarioVisto,
        fecha_crea AS fechaCrea
    FROM appchop.app_notas 
        WHERE id_sistema = _IDSISTEMA;
END $$
DELIMITER ;



/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_NOTAS_COBRADOR_GET;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_NOTAS_COBRADOR_GET(
    IN _IDSISTEMA VARCHAR(120), IN _USUARIO VARCHAR(150)
)
BEGIN
    SELECT
        N1.tabla AS tabla,
        N1.id_sistema AS idUsuario,
        N1.id_nota AS idNota,
        N1.id_cobranza AS idCobranza,
        N1.nota,
        N1.usuario_crea AS usuarioCrea,
        N1.usuario_visto AS usuarioVisto,
        N1.fecha_crea AS fechaCrea
    FROM appchop.app_notas N1
        LEFT OUTER JOIN appchop.app_cobranzas C1 ON N1.id_cobranza = C1.id_cobranza
        LEFT OUTER JOIN appchop.app_zonas_usuarios ZU1 ON C1.zona = ZU1.id_zona
    WHERE N1.id_sistema = _IDSISTEMA
        AND ZU1.usuario = _USUARIO;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_NOTAS_INSERT;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_NOTAS_INSERT(
    IN _TABLA VARCHAR(50), IN _IDSISTEMA VARCHAR(120), 
    IN _IDNOTA VARCHAR(120), IN _IDCOBRANZA VARCHAR(120),
    IN _NOTA VARCHAR(200), IN _USUARIOCREA VARCHAR(120),
    IN _USUARIOVISTO VARCHAR(120), IN _FECHACREA VARCHAR(10)
)
BEGIN
    DECLARE _VERIFY INT DEFAULT 0;
    SET _VERIFY = (
        SELECT 
            COUNT(*) AS VERIFY
        FROM appchop.app_notas WHERE 
            id_sistema = _IDSISTEMA 
            AND id_nota = _IDNOTA
    );
    IF _VERIFY = 0 THEN
        INSERT INTO appchop.app_notas (
            tabla, 
            id_sistema, 
            id_nota, 
            id_cobranza, 
            nota,
            usuario_crea,
            usuario_visto,
            fecha_crea
        ) VALUES (
            _TABLA, 
            _IDSISTEMA,
            _IDNOTA, 
            _IDCOBRANZA, 
            CONVERT(_NOTA USING UTF8),
            _USUARIOCREA,
            _USUARIOVISTO,
            _FECHACREA
        );
    ELSE
        IF _USUARIOVISTO = "" THEN
            UPDATE appchop.app_notas SET
                nota = CONVERT(_NOTA USING UTF8)
            WHERE
                id_sistema = _IDSISTEMA 
                AND id_nota = _IDNOTA;
        ELSE
            UPDATE appchop.app_notas SET
                nota = CONVERT(_NOTA USING UTF8),
                usuario_visto = _USUARIOVISTO
            WHERE
                id_sistema = _IDSISTEMA 
                AND id_nota = _IDNOTA;
        END IF;
    END IF;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_CLIENTES_GET;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_CLIENTES_GET(
    IN _IDSISTEMA VARCHAR(120), IN _ENCRYPTKEY VARCHAR(30)
)
BEGIN
    SELECT 
        tabla AS tabla,
        id_sistema AS idUsuario,
        id_cliente AS idCliente,
        CAST(AES_DECRYPT(nombre, _ENCRYPTKEY) AS CHAR) AS nombre,
        CAST(AES_DECRYPT(telefono, _ENCRYPTKEY) AS CHAR) AS telefono,
        fecha_creacion AS fechaCreacion,
        activo AS activobit
    FROM appchop.app_clientes
        WHERE id_sistema = _IDSISTEMA;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_CLIENTES_DELETE;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_CLIENTES_DELETE(
    IN _IDSISTEMA VARCHAR(120)
)
BEGIN
    DELETE FROM 
        appchop.app_clientes
    WHERE id_sistema = _IDSISTEMA;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_CLIENTES_INSERT;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_CLIENTES_INSERT(
    IN _TABLA VARCHAR(50), IN _IDSISTEMA VARCHAR(120), 
    IN _IDCLIENTE VARCHAR(120), IN _NOMBRE TEXT, 
    IN _TELEFONO TEXT, IN _FECHACREACION VARCHAR(10), 
    IN _ACTIVO BIT, IN _ENCRYPTKEY VARCHAR(30)
)
BEGIN
    INSERT INTO appchop.app_clientes (
        tabla, 
        id_sistema, 
        id_cliente, 
        nombre, 
        telefono, 
        fecha_creacion, 
        activo
    ) VALUES (
        _TABLA, 
        _IDSISTEMA, 
        _IDCLIENTE, 
        AES_ENCRYPT(CONVERT(_NOMBRE USING UTF8), _ENCRYPTKEY),
        AES_ENCRYPT(CONVERT(_TELEFONO USING UTF8), _ENCRYPTKEY),
        _FECHACREACION, 
        _ACTIVO
    );
END $$
DELIMITER ;



/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_INVENTARIOS_DELETE;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_INVENTARIOS_DELETE(
    IN _IDSISTEMA VARCHAR(120), IN _USUARIO VARCHAR(120)
)
BEGIN
    DELETE FROM 
        appchop.app_inventarios
    WHERE id_sistema = _IDSISTEMA
        AND usuario = _USUARIO;
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_INVENTARIOS_INSERT;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_INVENTARIOS_INSERT(
    IN _TABLA VARCHAR(50), IN _IDSISTEMA VARCHAR(120), IN _IDARTICULO VARCHAR(120), 
    IN _CODIGOARTICULO VARCHAR(120), IN _DESCRIPCION VARCHAR(40), IN _MARCA VARCHAR(40), 
    IN _TALLA VARCHAR(40), IN _PRECIOCOMPRA FLOAT, 
    IN _PRECIOVENTA FLOAT, IN _EXISTENCIA FLOAT, IN _MAXIMO FLOAT, 
    IN _MINIMO FLOAT, IN _FECHACAMBIO VARCHAR(10), IN _USUARIO VARCHAR(120) 
)
BEGIN
    INSERT INTO appchop.app_inventarios (
        tabla,
        id_sistema,
        id_articulo,
        codigo_articulo,
        descripcion,
        marca,
        talla,
        precio_compra,
        precio_venta,
        existencia,
        maximo,
        minimo,
        fecha_cambio,
        usuario
    ) VALUES (
        _TABLA,
        _IDSISTEMA,
        _IDARTICULO,
        _CODIGOARTICULO,
        CONVERT(_DESCRIPCION USING UTF8),
        CONVERT(_MARCA USING UTF8),
        CONVERT(_TALLA USING UTF8),
        _PRECIOCOMPRA,
        _PRECIOVENTA,
        _EXISTENCIA,
        _MAXIMO,
        _MINIMO,
        _FECHACAMBIO,
        _USUARIO
    );
END $$
DELIMITER ;


/* ------------------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS STP_APP_BACKUP_INVENTARIOS_GET;
DELIMITER $$
CREATE PROCEDURE STP_APP_BACKUP_INVENTARIOS_GET(
    IN _IDSISTEMA VARCHAR(120), IN _USUARIO VARCHAR(120)
)
BEGIN
    SELECT 
        tabla AS tabla,
        id_sistema AS idUsuario,
        id_articulo AS idArticulo,
        codigo_articulo AS codigoArticulo,
        descripcion,
        marca,
        talla,
        precio_compra AS precioCompra,
        precio_venta AS precioVenta,
        existencia,
        maximo AS maximo,
        minimo AS minimo,
        fecha_cambio AS fechaCambio,
        usuario
    FROM appchop.app_inventarios
        WHERE id_sistema = _IDSISTEMA
        AND usuario = _USUARIO;
END $$
DELIMITER ;


/* -------------------- AUX ------------------------------ */
DROP PROCEDURE IF EXISTS STP_ACTUALIZAR_SESION_AUX;
DELIMITER $$
CREATE PROCEDURE STP_ACTUALIZAR_SESION_AUX(
    IN _FUNCION VARCHAR(150),
    IN _IDSISTEMA VARCHAR(400),
    IN _USUARIO VARCHAR(400),
    IN _SESSION VARCHAR(400),
    IN _FIREBASE VARCHAR(400)
)
BEGIN
    INSERT INTO appchop.app_aux (
        funcion,
        value1, 
        value2, 
        value3, 
        value4
    ) VALUES (
        _FUNCION,
        _IDSISTEMA, 
        _USUARIO, 
        _SESSION, 
        _FIREBASE
    );
END $$
DELIMITER ;