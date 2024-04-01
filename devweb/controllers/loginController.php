<?php
    require('../services/loginService.php');
    $LoginService = new LoginService();
    $action = $_POST['action'];
    if(isset($_POST['data'])) {
        $data = $_POST['data'];
    }
    switch($action) {
        case "prueba":
            echo json_encode($LoginService->prueba($data));
            break;
        default:
            echo json_encode(false);
    }
?>