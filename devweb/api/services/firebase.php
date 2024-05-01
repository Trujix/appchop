<?php
    Class Firebase {
        public static function enviarNotificacion($params) {
            $key_fcm = getenv('FCMKEY');
            $api = new Api();
            $msg = self::crearNotificacionMsg(
                "Titulo de prueba",
                "Cuerpo de prueba"
            );
            $key_header = array("Authorization: key=$key_fcm");
            $result = $api->call(
                "https://fcm.googleapis.com/fcm/send",
                $msg,
                "POST",
                $key_header
            );
            return json_encode($result);
        }

        static function crearNotificacionMsg($titulo, $cuerpo) {
            $id_notificacion = bin2hex(openssl_random_pseudo_bytes(16));
            $notificacion = new stdClass();
            $notificacion->title = $titulo;
            $notificacion->body = $cuerpo;
            $android = new stdClass();
            $android->priority = "high";
            $data = new stdClass();
            $data->idnotificacion = $id_notificacion;
            $msg = new stdClass();
            $msg->registration_ids = array("eZ0P-jsDQG-TrvXMguE45Y:APA91bH-UZB_dnmpBo_kd1OY22ZQaCoktPc9BMo28EdDBkvUAF5McelMpiEgx8Ld8OEdKf9O-pxWFRJiWzFR3V9RldNCPne4j5EKMY8bIDpyG6tCmO2hAUS1uWFhU_aPkLbtLzcG6ayZ");
            $msg->notification = $notificacion;
            $msg->data = $data;
            $msg->priority = "high";
            $msg->android = $android;
            return $msg;
        }
    }
?>