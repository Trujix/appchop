<?php
    Class Usuarios {
        public static function altaUsuario($params) {

        }

        public static function validarUsuario($params) {
            Auth::verify();
            if(!isset($params[0]) || !isset($params[1]) || count($params) == 0) {
                http_response_code(406);
                die("Parámetros de usuario incorrectos");
            }
            $id_usuario = $params[0];
            $usuario = $params[1];
            $activo = "ACTIVO";
            $mysql = new Mysql();
            $estatus = $mysql->executeReader(
                "CALL STP_VERIFICAR_ESTATUS_USUARIO('$id_usuario', '$usuario')",
                true
            );
            if($estatus->status != $activo) {
                return "ERROR-ESTATUS";
            }
            $perfil = $mysql->executeReader(
                "CALL STP_VERIFICAR_PERFIL_USUARIO('$id_usuario', '$usuario')",
                true
            );
            if($perfil->perfil != "ADMINISTRADOR") {
                $zona_usuario = $mysql->executeReader(
                    "CALL STP_APP_BACKUP_ZONASUSUARIOS_VERIFY('$id_usuario', '$usuario')",
                    true
                );
                if($zona_usuario->VERIFY <= 0) {
                    return "ERROR-ZONA";
                }
                $accion_usuario = $mysql->executeReader(
                    "CALL STP_APP_BACKUP_ACCION_GET('$id_usuario', '$usuario')",
                    true
                );
                if($accion_usuario->accion != "-") {
                    return $accion_usuario->accion;
                }
            }
            return "OK";
        }

        public static function verificarEstatus($params) {
            Auth::verify();
            if(!isset($params[0]) || !isset($params[1]) || count($params) == 0) {
                http_response_code(406);
                die("Parámetros de usuario incorrectos");
            }
            $id_usuario = $params[0];
            $usuario = $params[1];
            $mysql = new Mysql();
            $verificar = $mysql->executeReader(
                "CALL STP_VERIFICAR_ESTATUS_USUARIO('$id_usuario', '$usuario')",
                true
            );
            return $verificar->status;
        }

        public static function eliminarUsuarioAccion($params) {
            Auth::verify();
            if(!isset($params[0]) || !isset($params[1]) || count($params) == 0) {
                http_response_code(406);
                die("Parámetros de usuario incorrectos");
            }
            $id_usuario = $params[0];
            $usuario = $params[1];
            $mysql = new Mysql();
            $eliminar_accion = $mysql->executeNonQuery(
                "CALL STP_APP_BACKUP_ACCION_DELETE(
                    '$id_usuario', '$usuario'
                )"
            );
            return json_encode($eliminar_accion == 1);
        }
    }
?>