<?php
    Class Email {
        function __construct() { }

        public function nuevoPassword($para, $codigo) {
            $título = 'Nueva contraseña';
            $mensaje = "$codigo - es su contraseña temporal";
            $enviar_email = $this->send($para, $título, $mensaje);
            return $enviar_email;
        }

        public function send($para, $título, $mensaje) {
            $cabeceras = "MIME-Version: 1.0".PHP_EOL;
            $cabeceras .= "Content-Type: text/html; charset=UTF-8".PHP_EOL;
            $cabeceras .= "From: Soporte<mail.appchop.com>\r\n";
            return mail($para, $título, $mensaje, $cabeceras);
        }
    }
?>