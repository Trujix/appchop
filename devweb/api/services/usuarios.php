<?php
    Class Usuarios {
        public static function altaUsuario($params) {

        }

        public static function verificarEstatus($params) {
            Auth::verify();
            if(!isset($params[0]) || !isset($params[1]) || count($params) == 0) {
                http_response_code(406);
                die("Parámetros de usuario incorrectos");
            }
            $id_usuario = $params[0];
            $perfil = $params[1];
            $mysql = new Mysql();
            $verificar = $mysql->executeReader(
                "CALL STP_VERIFICAR_ESTATUS_USUARIO('$id_usuario', '$perfil')",
                true
            );
            return $verificar->status;
        }
    }
?>