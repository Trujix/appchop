<?php
    Class Login {
        public static function iniciarSesion($params) {
            $login_form = (object)$params;
            if(!isset($login_form->usuario) 
                || !isset($login_form->password)) {
                http_response_code(406);
                die("Parámetros de inicio de sesión incorrectos");
            }
            $mysql = new Mysql();
            $resultado_login = $mysql->executeReader(
                "CALL STP_INICIAR_SESION('{$login_form->usuario}', '{$login_form->password}')",
                true
            );
            try {
                $resultado_actualizar = $mysql->executeNonQuery(
                    "CALL STP_ACTUALIZAR_SESION_AUX(
                        'STP_INICIAR_SESION',
                        '$resultado_login->id_sistema',
                        '$resultado_login->usuario',
                        '$resultado_login->sesion',
                        '$resultado_login->id_firebase'
                    )"
                );
            } finally { }
            return json_encode($resultado_login);
        }

        public static function recuperarPassword($params) {
            $password_form = (object)$params;
            if(!isset($password_form->usuario)) {
                http_response_code(406);
                die("Parámetros de contraseña incorrectos");
            }
            $usuario = $password_form->usuario;
            $mysql = new Mysql();
            $verificar_usuario = $mysql->executeReader(
                "CALL STP_VERIFICAR_USUARIO('$usuario')",
                true
            );
            if($verificar_usuario->EXISTE <= 0) {
                return "NO-USUARIO";
            }
            $nueva_pass = rand(100000, 199999);
            $actualizar_password = $mysql->executeNonQuery(
                "CALL STP_RECUPERACION_USUARIO_PASSWORD('$usuario', '$nueva_pass', 'PASSTEMPORAL')"
            );
            $email = new Email();
            if($email->nuevoPassword($usuario, $nueva_pass)) {
                return "PASSWORD-ENVIADO";
            }
            return "ERROR";
        }

        public static function actualizarPassword($params) {
            Auth::verify();
            $password_form = (object)$params;
            if(!isset($password_form->usuario)
                || !isset($password_form->password)) {
                http_response_code(406);
                die("Parámetros de contraseña incorrectos");
            }
            $usuario = $password_form->usuario;
            $nueva_pass = $password_form->password;
            $mysql = new Mysql();
            $actualizar_password = $mysql->executeNonQuery(
                "CALL STP_RECUPERACION_USUARIO_PASSWORD('$usuario', '$nueva_pass', 'ACTIVO')"
            );
            return json_encode($actualizar_password == 1);
        }

        public static function actualizarUsuario($params) {
            Auth::verify();
            $usuario_form = (object)$params;
            if(!isset($usuario_form->idUsuario)
                || !isset($usuario_form->usuario)
                || !isset($usuario_form->sesion)
                || !isset($usuario_form->firebase)) {
                http_response_code(406);
                die("Parámetros de actualización incorrectos");
            }
            $mysql = new Mysql();
            $resultado_actualizar = $mysql->executeNonQuery(
                "CALL STP_ACTUALIZAR_SESION(
                    '$usuario_form->idUsuario',
                    '$usuario_form->usuario',
                    '$usuario_form->sesion',
                    '$usuario_form->firebase'
                )"
            );
            return json_encode($resultado_actualizar == 1);
        }

        public static function acpetaTerminosCondiciones($params) {
            Auth::verify();
            $acepta_form = (object)$params;
            if(!isset($acepta_form->idUsuario)
                || !isset($acepta_form->acepta)) {
                http_response_code(406);
                die("Parámetros de configuración incorrectos");
            }
            $mysql = new Mysql();
            $resultado_aceptar = $mysql->executeNonQuery(
                "CALL STP_ACEPTA_ACTUALIZAR('$acepta_form->idUsuario', $acepta_form->acepta)"
            );
            return json_encode($resultado_aceptar == 1);
        }
    }
?>