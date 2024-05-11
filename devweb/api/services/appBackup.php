<?php
    Class AppBackup {
        public static function descargar($params) {
            Auth::verify();
            if(!isset($params[0]) || count($params) == 0) {
                http_response_code(406);
                die("Parámetros de usuario incorrectos");
            }
            $id_usuario = $params[0];
            $app_backup = new stdClass();
            $mysql = new Mysql();
            $usuarios = $mysql->executeReader(
                "CALL STP_APP_BACKUP_USUARIOS_GET('$id_usuario')",
            );
            foreach($usuarios as $usuario) {
                $usuario->activo = $usuario->estatus > 0;
            }
            $zonas = $mysql->executeReader(
                "CALL STP_APP_BACKUP_ZONAS_GET('$id_usuario')",
            );
            foreach($zonas as $zona) {
                $zona->activo = $zona->activobit > 0;
            }
            $zonas_usuarios = $mysql->executeReader(
                "CALL STP_APP_BACKUP_ZONASUSUARIOS_GET('$id_usuario')",
            );
            $app_backup->usuarios = $usuarios;
            $app_backup->zonas = $zonas;
            $app_backup->zonasUsuarios = $zonas_usuarios;
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