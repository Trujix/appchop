<?php
    Class Api {
        public function call($url, $data, $tipo, $headers = array()) {
            try {
                $curl = curl_init();
                curl_setopt($curl, CURLOPT_URL, $url);
                curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, 0);
                curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
                curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
                $set_headers = array();
                $set_headers[] = "Content-type: application/json";
                foreach($headers as $header) {
                    $set_headers[] = $header;
                }
                curl_setopt($curl, CURLOPT_HTTPHEADER, $set_headers);
                if($tipo == "POST") {
                    curl_setopt($curl, CURLOPT_POST, true);
                    curl_setopt($curl, CURLOPT_POSTFIELDS, json_encode($data));
                } else if($tipo == "GET") {
                    curl_setopt($curl, CURLOPT_HTTPGET , true);
                }
                $response = curl_exec($curl);
                $status = curl_getinfo($curl, CURLINFO_HTTP_CODE);
                if($status != 200) {
                    return null;
                }
                curl_close($curl);
                return json_decode($response);
            } catch(Exception $e) {
                return null;
            }
        }
    }
?>