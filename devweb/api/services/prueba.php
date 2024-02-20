<?php
    Class Prueba {

        public static function ejecutarPrueba($data) {
            Auth::verify();

            die(json_encode($data));
        }

    }
?>