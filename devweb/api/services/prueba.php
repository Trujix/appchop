<?php
    Class Prueba {
        public static function ejecutarPrueba($data) {
            //Auth::verify();
            //die(json_encode($data[0]));

            $mysql = new Mysql();
            $consulta = $mysql->executeReader(
                "SELECT * FROM usuarios WHERE nombre = 'diegoxxx'", true
            );
            echo json_encode($consulta);
            /*$mysql = new Mysql();
            $json = (object)$data;
            $result = $mysql->executeNonQuery(
                "INSERT INTO usuarios 
                    (nombre, edad) 
                VALUES ('$json->nombre', $json->edad)"
            );
            if($result) {
                echo "corrrecto";
            } else {
                echo "error".$result;
            }*/
        }
    }
?>