<?php
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Credentials: true');
    header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
    header('Access-Control-Allow-Headers: X-Requested-With');
    header('Content-Type: text/html; charset=utf-8');
    header('P3P: CP="IDC DSP COR CURa ADMa OUR IND PHY ONL COM STA"');

    $services_list = array();
    foreach(glob('services/*.php') as $service) {
        array_push(
            $services_list,
            strtolower(str_replace('.php', '', str_replace('services/', '', $service)))
        );
        require_once($service);
    }

    foreach(glob('../parameters/*.php') as $parameter) {
        require($parameter);
    }

    if(isset($_GET['PATH_INFO']) == "") {
        http_response_code(400);
        die('<h1>Api version 1</h1>');
    }

    $path_info = explode('/', strval($_GET['PATH_INFO']));
    if(!isset($path_info)) {
        http_response_code(400);
        die('Entrada de solicitud NO válida');
    }
    if(count($path_info) == 0 || count($path_info) < 2) {
        http_response_code(400);
        die('La solicitud es Incorrecta');
    }
    $servicio = strtolower($path_info[0]);
    $funcion = strtolower($path_info[1]);
    $params;
    if(!in_array($servicio, $services_list)) {
        http_response_code(404);
        die('Solicitud de servicio NO válida');
    }
    switch($_SERVER['REQUEST_METHOD']) {
        case 'POST':
            $params = json_decode(file_get_contents('php://input'), true);
        break;
        case 'GET':
            $url_data = array();
            for ($i = 2; $i < count($path_info); $i++) { 
                array_push($url_data, $path_info[$i]);
            }
            if(count($url_data) > 0) {
                $params = $url_data;
            }
        break;
        default:
            http_response_code(405);
            die('Método NO permitido');
        break;
    }

    if(!isset($params)) {
        http_response_code(406);
        die('Error en los parámetros proporcionados');
    }

    $headers = apache_request_headers();
    if(isset($headers['Authorization'])) {
        session_start();
        $_SESSION['Token'] = $headers['Authorization'];
    }

    try {
        set_time_limit(18000);
        date_default_timezone_set('America/Mexico_City');
        echo call_user_func(array($servicio, $funcion), $params);
    } catch(Exception $e) {
        http_response_code(500);
        die($e->getMessage());
    }
?>