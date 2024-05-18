<?php
    Class AppBackup {
        public static function sincronizar($params) {
            Auth::verify();
            $backup_data = (object)$params;
            if(!isset($backup_data->usuarioEnvia) 
                || !isset($backup_data->cobranzas)
                || !isset($backup_data->cargosAbonos)
                || !isset($backup_data->notas)
                || !isset($backup_data->clientes)
                || !isset($backup_data->inventarios)
                || !isset($backup_data->borrados)
                || !isset($backup_data->usuarios)
                || !isset($backup_data->zonas)
                || !isset($backup_data->zonasUsuarios)) {
                http_response_code(406);
                die("Parámetros de backup incorrectos");
            }
            $encryption_key = getenv('ENCRYPTKEY');
            $usuario_envia = $backup_data->usuarioEnvia;
            $cobranzas = array();
            $mysql = new Mysql();
            foreach($backup_data->cobranzas as $array_cobranza) {
                $cobranza = (object)$array_cobranza;
                $agregar_cobranza = $mysql->executeNonQuery(
                    "CALL STP_APP_BACKUP_COBRANZAS_PROCESS(
                        '$cobranza->tabla', '$cobranza->idUsuario', '$cobranza->idCobranza', 
                        '$cobranza->tipoCobranza', '$cobranza->zona', '$cobranza->nombre', 
                        $cobranza->cantidad , '$cobranza->descripcion', '$cobranza->telefono', 
                        '$cobranza->direccion', '$cobranza->correo', '$cobranza->fechaRegistro', 
                        '$cobranza->fechaVencimiento', $cobranza->saldo , '$cobranza->latitud', 
                        '$cobranza->longitud', '$cobranza->ultimoCargo' , '$cobranza->fechaUltimoCargo', 
                        '$cobranza->usuarioUltimoCargo', $cobranza->ultimoAbono , '$cobranza->fechaUltimoAbono', 
                        '$cobranza->usuarioUltimoAbono', '$cobranza->estatus', '$cobranza->bloqueado', 
                        '$cobranza->idCobrador', '$encryption_key', '$usuario_envia'
                    )"
                );
            }
            die($encryption_key);
        }

        public static function verificarBackup($params) {
            Auth::verify();
            if(!isset($params[0]) || count($params) == 0) {
                http_response_code(406);
                die("Parámetros de usuario incorrectos");
            }
            $id_usuario = $params[0];
            $mysql = new Mysql();
            $backup_verificar = $mysql->executeReader(
                "CALL STP_APP_VERIFICAR_BACKUP('$id_usuario')",
                true
            );
            die(json_encode($backup_verificar));
        }

        public static function descargar($params) {
            Auth::verify();
            if(!isset($params[0]) || !isset($params[1]) || count($params) == 0) {
                http_response_code(406);
                die("Parámetros de usuario incorrectos");
            }
            $id_usuario = $params[0];
            $usuario = $params[1];
            $esAdmin = $usuario == "ADMINISTRADOR";
            $cobranzas = array();
            $usuarios = array();
            $zonas = array();
            $zonas_usuarios = array();
            $app_backup = new stdClass();
            $mysql = new Mysql();
            $zonas = $mysql->executeReader(
                $esAdmin ? "CALL STP_APP_BACKUP_ZONAS_GET('$id_usuario')"
                : "CALL STP_APP_BACKUP_ZONAS_COBRADOR_GET('$id_usuario', '$usuario')",
            );
            foreach($zonas as $zona) {
                $zona->activo = $zona->activobit > 0;
            }
            if($esAdmin) {
                $usuarios = $mysql->executeReader(
                    "CALL STP_APP_BACKUP_USUARIOS_GET('$id_usuario')",
                );
                foreach($usuarios as $usuario) {
                    $usuario->activo = $usuario->estatus > 0;
                }
                $zonas_usuarios = $mysql->executeReader(
                    "CALL STP_APP_BACKUP_ZONASUSUARIOS_GET('$id_usuario')",
                );
            }
            $app_backup->usuarios = isset($usuarios[0]->idUsuario) ? $usuarios : array();
            $app_backup->zonas = isset($zonas[0]->idUsuario) ? $zonas : array();
            $app_backup->zonasUsuarios = isset($zonas_usuarios[0]->idUsuario) ? $zonas_usuarios : array();
            return json_encode($app_backup);
        }

        public static function backupZonas($params) {
            self::init($params);
            $zonas_lista = array();
            foreach($params as $zona_param) {
                array_push($zonas_lista, (object)$zona_param);
            }
            $id_usuario = $zonas_lista[0]->idUsuario;
            $mysql = new Mysql();
            $restablecer_zonas = $mysql->executeNonQuery(
                "CALL STP_APP_BACKUP_ZONAS_DELETE('$id_usuario')"
            );
            $zonas_add = 0;
            foreach($zonas_lista as $zona) {
                $activo = $zona->activo ? 1 : 0;
                $agregar_zona = $mysql->executeNonQuery(
                    "CALL STP_APP_BACKUP_ZONAS_INSERT(
                        '$zona->tabla',
                        '$zona->idUsuario',
                        '$zona->idZona',
                        '$zona->valueZona',
                        '$zona->labelZona',
                        '$zona->fechaCreacion',
                        $activo
                    )"
                );
                $zonas_add = $zonas_add + $agregar_zona;
            }
            return json_encode($zonas_add > 0);
        }

        public static function backupZonasUsuarios($params) {
            self::init($params);
            $zonas_usuarios_lista = array();
            foreach($params as $zona_param) {
                array_push($zonas_usuarios_lista, (object)$zona_param);
            }
            $id_usuario = $zonas_usuarios_lista[0]->idUsuario;
            $mysql = new Mysql();
            $restablecer_zonas_usuarios = $mysql->executeNonQuery(
                "CALL STP_APP_BACKUP_ZONASUSUARIOS_DELETE('$id_usuario')"
            );
            $zonas_usuarios_add = 0;
            foreach($zonas_usuarios_lista as $zona_usuario) {
                $agregar_zona = $mysql->executeNonQuery(
                    "CALL STP_APP_BACKUP_ZONASUSUARIOS_INSERT(
                        '$zona_usuario->tabla',
                        '$zona_usuario->idUsuario',
                        '$zona_usuario->idZona',
                        '$zona_usuario->usuario'
                    )"
                );
                $zonas_usuarios_add = $zonas_usuarios_add + $agregar_zona;
            }
            return json_encode($zonas_usuarios_add > 0);
        }

        static function init($params) {
            Auth::verify();
            if(!isset($params[0]) || count($params) == 0) {
                http_response_code(406);
                die("Listado vacio");
            }
        }
    }
?>