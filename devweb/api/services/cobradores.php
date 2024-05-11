<?php
    Class Cobradores {
        public static function verificarCobrador($params) {
            Auth::verify();
            if(!isset($params[0]) || !isset($params[1]) || count($params) == 0) {
                http_response_code(406);
                die("Parámetros de cobrador incorrectos");
            }
            $id_usuario = $params[0];
            $usuario = $params[1];
            $mysql = new Mysql();
            $verificar = $mysql->executeReader(
                "CALL STP_VERIFICAR_COBRADOR('$id_usuario', '$usuario')",
                true
            );
            return json_encode($verificar->EXISTE == 0);
        }

        public static function altaCobrador($params) {
            Auth::verify();
            $alta_form = (object)$params;
            if(!isset($alta_form->idUsuario) 
                || !isset($alta_form->usuario)
                || !isset($alta_form->password)
                || !isset($alta_form->nombres)
                || !isset($alta_form->apellidos)) {
                http_response_code(406);
                die("Parámetros de registro incorrectos");
            }
            $mysql = new Mysql();
            $alta = $mysql->executeNonQuery(
                "CALL STP_ALTA_COBRADOR(
                    '$alta_form->idUsuario', '$alta_form->usuario', '$alta_form->password',
                    '$alta_form->nombres', '$alta_form->apellidos' 
                )"
            );
            return json_encode($alta == 1);
        }

        public static function actualizarPassword($params) {
            Auth::verify();
            $password_form = (object)$params;
            if(!isset($password_form->idUsuario) 
                || !isset($password_form->usuario)
                || !isset($password_form->password)) {
                http_response_code(406);
                die("Parámetros de usuario incorrectos");
            }
            $mysql = new Mysql();
            $actualizar = $mysql->executeNonQuery(
                "CALL STP_ACTUALIZAR_PASSWORD_COBRADOR(
                    '$password_form->idUsuario', '$password_form->usuario',
                    '$password_form->password'
                )"
            );
            return json_encode($actualizar == 1);
        }

        public static function consultarCobradorInfo($params) {
            Auth::verify();
            if(!isset($params[0]) || !isset($params[1]) || count($params) == 0) {
                http_response_code(406);
                die("Parámetros de cobrador incorrectos");
            }
            $id_usuario = $params[0];
            $usuario = $params[1];
            $mysql = new Mysql();
            $cobrador_info = $mysql->executeReader(
                "CALL STP_OBTENER_COBRADOR_INFO(
                    '$id_usuario', '$usuario'
                )",
                true
            );
            return json_encode($cobrador_info);
        }

        public static function actualizarEstatus($params) {
            Auth::verify();
            $estatus_form = (object)$params;
            if(!isset($estatus_form->idUsuario) 
                || !isset($estatus_form->usuario)
                || !isset($estatus_form->estatus)) {
                http_response_code(406);
                die("Parámetros de usuario incorrectos");
            }
            $mysql = new Mysql();
            $actualizar = $mysql->executeNonQuery(
                "CALL STP_ACTUALIZAR_ESTATUS_COBRADOR(
                    '$estatus_form->idUsuario', '$estatus_form->usuario',
                    '$estatus_form->estatus'
                )"
            );
            return json_encode($actualizar == 1);
        }
    }
?>