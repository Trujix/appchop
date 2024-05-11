<?php
    Class Firebase {
        public static function enviarNotificacion($params) {
            Auth::verify();
            $notif_form = (object)$params;
            if(!isset($notif_form->titulo) 
                || !isset($notif_form->cuerpo)
                || !isset($notif_form->ids)
                || !isset($notif_form->data)) {
                http_response_code(406);
                die("Parámetros de notificación incorrectos");
            }
            $key_fcm = getenv('FCMKEY');
            $api = new Api();
            $msg = self::crearNotificacionMsg(
                $notif_form->titulo,
                $notif_form->cuerpo,
                $notif_form->ids,
                $notif_form->data
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

        static function crearNotificacionMsg($titulo, $cuerpo, $ids, $data) {
            $id_notificacion = bin2hex(openssl_random_pseudo_bytes(16));
            $notificacion = new stdClass();
            $notificacion->title = $titulo;
            $notificacion->body = $cuerpo;
            $android = new stdClass();
            $android->priority = "high";
            $data['idnotificacion'] = $id_notificacion;
            $msg = new stdClass();
            $msg->registration_ids = $ids;
            $msg->notification = $notificacion;
            $msg->data = $data;
            $msg->priority = "high";
            $msg->android = $android;
            return $msg;
        }
    }
?>