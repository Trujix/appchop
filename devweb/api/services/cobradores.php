<?php
    Class Cobradores {
        public static function verificarCobrador($params) {
            if(!isset($params[0]) || !isset($params[1]) || count($params) == 0) {
                http_response_code(406);
                die("Parámetros de cobrador incorrectos");
            }
            $id_sistema = $params[0];
            $usuario = $params[0];
            $mysql = new Mysql();
            $verificar = $mysql->executeReader(
                "CALL STP_VERIFICAR_COBRADOR('$id_sistema', '$usuario')",
                true
            );
            return json_encode($verificar->EXISTE > 0);
        }
    }
?>