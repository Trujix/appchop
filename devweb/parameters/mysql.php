<?php
    Class Mysql {
        var $conn;

        function __construct() {
            $this->conection();
        }

        public function conection() {
            $this->conn = mysqli_init();
            $this->conn->options(MYSQLI_OPT_CONNECT_TIMEOUT, 300);
            $this->conn->options(MYSQLI_SET_CHARSET_NAME, "utf8");
            $this->conn->real_connect(
                "localhost",
                "root",
                "root",
                "prueba"
            );
        }

        public function executeReader($query, $single = false) {
            $resultado = array();
            if($execute_query = $this->conn->query($query)) {
                while($reader = $execute_query->fetch_object()) {
                    $resultado[] = $reader;
                }
                while ($this->conn->more_results() && $this->conn->next_result());
                if(count($resultado) > 0 && $single) {
                    $resultado = $resultado[0];
                }
            }
            return $resultado;
        }

        public function executeNonQuery($query) {
            $resultado = $this->conn->query($query);
            if(!$resultado) {
                return $this->conn->connect_error;
            } else {
                do {
                } while(
                    mysqli_more_results($this->conn) && mysqli_next_result($this->conn)
                );
                return $resultado;
            }
        }
    }
?>