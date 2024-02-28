<?php
    Class Auth {
        function __construct() {

        }

        public static function verify() {
            if(!isset($_SESSION['Token'])) {
                http_response_code(401);
                die('No autorizado');
            }
            $token = $_SESSION['Token'];
            if($token != "diego2024") {
                http_response_code(401);
                die('No autorizado');
            }
        }
    }
?>