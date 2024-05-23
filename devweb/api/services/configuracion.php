<?php
    Class Configuracion {
        public static function desvincularDispositivo($params) {
            Auth::verify();
            if(!isset($params[0]) || !isset($params[1]) || count($params) == 0) {
                http_response_code(406);
                die("Parámetros de dispositivo incorrectos");
            }
            $mysql = new Mysql();
            $resultado_desvincular = $mysql->executeNonQuery(
                "CALL STP_ACTUALIZAR_SESION('{$params[0]}', '{$params[1]}', 'NONE', 'NONE')"
            );
            return json_encode($resultado_desvincular == 1);
        }

        public static function obtenerConfiguracionUsuario($params) {
            Auth::verify();
            if(!isset($params[0]) || count($params) == 0) {
                http_response_code(406);
                die("Parámetros de usuario incorrectos");
            }
            $id_usuario = $params[0];
            $mysql = new Mysql();
            $resultado_configuracion = $mysql->executeReader(
                "CALL STP_OBTENER_CONFIGURACION_USUARIO('{$id_usuario}')",
                true
            );
            return json_encode($resultado_configuracion);
        }
    }
?>