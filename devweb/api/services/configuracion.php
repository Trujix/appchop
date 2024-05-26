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
                "CALL STP_ACTUALIZAR_SESION(
                    '{$params[0]}',
                    '{$params[1]}',
                    'NONE', 'NONE'
                )"
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

        public static function guardarImagenLogo($params) {
            Auth::verify();
            $imagen_logo = (object)$params;
            if(!isset($imagen_logo->idUsuario) 
                || !isset($imagen_logo->imagenBase64)) {
                http_response_code(406);
                die("Parámetros de notificación incorrectos");
            }
            $imagen_base64 = base64_decode($imagen_logo->imagenBase64);
            file_put_contents("../media/usuarios/{$imagen_logo->idUsuario}.jpg", $imagen_base64);
            return json_encode(true);
        }
    }
?>