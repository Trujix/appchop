<?php
    Class Email {
        function __construct() { }

        public static function enviar() {
            $para  = 'yitogarcia51@gmail.com';

            $título = 'Codigo de seguridad 4';

            $mensaje = '<html><body><h1 style="color: red;">Hola Diego</h1></body</html>';

            $cabeceras = "MIME-Version: 1.0".PHP_EOL;
            $cabeceras .= "Content-Type: text/html; charset=UTF-8".PHP_EOL;
            $cabeceras .= "From: Soporte<mail.appchop.com>\r\n";

            return mail($para, $título, $mensaje, $cabeceras);
        }
    }
?>