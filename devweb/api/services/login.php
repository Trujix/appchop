<?php
    Class Login {
        public static function iniciarSesion($params) {
            $login_form = (object)$params;
            if(!isset($login_form->usuario) 
                || !isset($login_form->password)) {
                http_response_code(406);
                die("Parámetros de inicio de sesión incorrecto");
            }
            $mysql = new Mysql();
            $resultado_login = $mysql->executeReader(
                "CALL STP_INICIAR_SESION('{$login_form->usuario}', '{$login_form->password}')",
                true
            );
            return json_encode($resultado_login);
        }

        public static function actualizarUsuario($params) {
            Auth::verify();
            $usuario_form = (object)$params;
            if(!isset($usuario_form->idUsuario)
                || !isset($usuario_form->sesion)
                || !isset($usuario_form->firebase)) {
                http_response_code(406);
                die("Parámetros de inicio de sesión incorrecto");
            }
            $mysql = new Mysql();
            $resultado_actualizar = $mysql->executeNonQuery(
                "CALL STP_ACTUALIZAR_SESION('$usuario_form->idUsuario',
                '$usuario_form->sesion', '$usuario_form->firebase')"
            );
            return json_encode($resultado_actualizar == 1);
        }
    }
?>