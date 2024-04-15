<?php
    Class Configuracion {
        public static function desvincularDispositivo($params) {
            if(!isset($params[0]) || count($params) == 0) {
                http_response_code(406);
                die("Parámetros de dispositivo incorrectos");
            }
            $mysql = new Mysql();
            $resultado_desvincular = $mysql->executeNonQuery(
                "CALL STP_ACTUALIZAR_SESION('{$params[0]}', 'NONE', 'NONE')"
            );
            return json_encode($resultado_desvincular == 1);
        }
    }
?>