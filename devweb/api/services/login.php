<?php
    Class Login {
        public static function iniciarSesion($params) {
            $login_form = (object)$params;
            if(!isset($login_form->usuario) 
                || !isset($login_form->password)
                || !isset($login_form->firebase)) {
                http_response_code(406);
                die("Parámetros de inicio de sesión incorrecto");
            }
            $mysql = new Mysql();
            $resultado_login = $mysql->executeReader(
                "CALL STP_INICIAR_SESION('{$login_form->usuario}', 
                '{$login_form->password}', '{$login_form->firebase}')",
                true
            );
            return json_encode($resultado_login);
        }

        public static function actualizarSesion($params) {

        }
    }
?>