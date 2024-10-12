<?php
    Class AppBackup {
        public static function sincronizar($params) {
            Auth::verify();
            $backup_data = (object)$params;
            if(!isset($backup_data->idUsuario) 
                || !isset($backup_data->usuarioEnvia)
                || !isset($backup_data->cobranzas)
                || !isset($backup_data->cargosAbonos)
                || !isset($backup_data->notas)
                || !isset($backup_data->clientes)
                || !isset($backup_data->inventarios)
                || !isset($backup_data->borrados)
                || !isset($backup_data->usuarios)
                || !isset($backup_data->zonas)
                || !isset($backup_data->zonasUsuarios)) {
                http_response_code(406);
                die("Parámetros de backup incorrectos");
            }
            $encryption_key = getenv('ENCRYPTKEY');
            $id_usuario = $backup_data->idUsuario;
            $usuario = $backup_data->usuarioEnvia;
            $esAdmin = $usuario == "ADMINISTRADOR";
            $usuario_envia = $backup_data->usuarioEnvia;
            $mysql = new Mysql();
            foreach($backup_data->cobranzas as $array_cobranza) {
                $cobranza = (object)$array_cobranza;
                $agregar_cobranza = $mysql->executeNonQuery(
                    "CALL STP_APP_BACKUP_COBRANZAS_PROCESS(
                        '$cobranza->tabla', '$cobranza->idUsuario', '$cobranza->idCobranza', 
                        '$cobranza->tipoCobranza', '$cobranza->zona', '$cobranza->nombre', 
                        $cobranza->cantidad, '$cobranza->descripcion', '$cobranza->telefono', 
                        '$cobranza->direccion', '$cobranza->correo', '$cobranza->fechaRegistro', 
                        '$cobranza->fechaVencimiento', $cobranza->saldo , '$cobranza->latitud', 
                        '$cobranza->longitud', '$cobranza->ultimoCargo' , '$cobranza->fechaUltimoCargo', 
                        '$cobranza->usuarioUltimoCargo', $cobranza->ultimoAbono , '$cobranza->fechaUltimoAbono', 
                        '$cobranza->usuarioUltimoAbono', '$cobranza->estatus', '$cobranza->bloqueado', 
                        '$cobranza->idCobrador', '$cobranza->estatusManual', '$encryption_key', '$usuario_envia'
                    )"
                );
            }
            foreach($backup_data->cargosAbonos as $array_cargos_abonos) {
                $cargo_abono = (object)$array_cargos_abonos;
                $agregar_cargos_abonos = $mysql->executeNonQuery(
                    "CALL STP_APP_BACKUP_CARGOSABONOS_INSERT(
                        '$cargo_abono->tabla', '$cargo_abono->idUsuario', '$cargo_abono->idCobranza', 
                        '$cargo_abono->idMovimiento', '$cargo_abono->tipo', $cargo_abono->monto, 
                        '$cargo_abono->referencia', '$cargo_abono->usuarioRegistro', 
                        '$cargo_abono->fechaRegistro', '$cargo_abono->genera'
                    )"
                );
            }
            foreach($backup_data->notas as $array_notas) {
                $nota = (object)$array_notas;
                $agregar_notas = $mysql->executeNonQuery(
                    "CALL STP_APP_BACKUP_NOTAS_INSERT(
                        '$nota->tabla', '$nota->idUsuario', '$nota->idNota', 
                        '$nota->idCobranza', '$nota->nota', '$nota->usuarioCrea',
                        '$nota->usuarioVisto', '$nota->fechaCrea'
                    )"
                );
            }
            if($esAdmin) {
                $clientes_backup = self::crearAppBackupClientes($id_usuario, $backup_data->clientes);
                $zonas_backup = self::crearAppBackupZonas($id_usuario, $backup_data->zonas);
                $zonas_usuarios_backup = self::crearAppBackupZonasUsuarios($id_usuario, $backup_data->zonasUsuarios);
                $inventarios_backup = self::crearAppBackupInventarios($id_usuario, $usuario, $backup_data->inventarios);
            }
            $id_backup = self::guid();
            $backup_fecha_creacion = date('d-m-Y');
            $crear_backup = $mysql->executeNonQuery(
                "CALL STP_APP_LOGBACKUP_PROCESS(
                    '$id_usuario', '$id_backup', 
                    '$usuario', '$backup_fecha_creacion'
                )"
            );
            $app_backup = self::crearAppBackup($id_usuario, $usuario);
            $app_backup->idBackup = $id_backup;
            return json_encode($app_backup);
        }

        public static function verificarBackup($params) {
            Auth::verify();
            if(!isset($params[0]) || count($params) == 0) {
                http_response_code(406);
                die("Parámetros de usuario incorrectos");
            }
            $id_usuario = $params[0];
            $mysql = new Mysql();
            $backup_verificar = $mysql->executeReader(
                "CALL STP_APP_VERIFICAR_BACKUP('$id_usuario')",
                true
            );
            die(json_encode($backup_verificar));
        }

        public static function descargar($params) {
            Auth::verify();
            if(!isset($params[0]) || !isset($params[1]) || count($params) == 0) {
                http_response_code(406);
                die("Parámetros de usuario incorrectos");
            }
            $app_backup = self::crearAppBackup($params[0], $params[1]);
            return json_encode($app_backup);
        }

        public static function backupZonas($params) {
            self::init($params);
            $primer_zona = (object)$params[0];
            $id_usuario = $primer_zona->idUsuario;
            $zonas_add = self::crearAppBackupZonas($id_usuario, $params);            
            return json_encode($zonas_add > 0);
        }

        public static function backupZonasUsuarios($params) {
            self::init($params);
            $primer_zona_usuario = (object)$params[0];
            $id_usuario = $primer_zona_usuario->idUsuario;
            $zonas_usuarios_add = self::crearAppBackupZonasUsuarios($id_usuario, $params);
            return json_encode($zonas_usuarios_add > 0);
        }

        public static function removerZonasUsuarios($params) {
            Auth::verify();
            if(!isset($params[0]) || count($params) == 0) {
                http_response_code(406);
                die("Parámetros de zonas-usuario incorrectos");
            }
            $id_usuario = $params[0];
            $mysql = new Mysql();
            $remover_zonas_usuarios = $mysql->executeNonQuery(
                "CALL STP_APP_BACKUP_ZONASUSUARIOS_DELETE('$id_usuario')"
            );
            return json_encode($remover_zonas_usuarios > 0);
        }

        public static function desbloquearCobranzasAdministrador($params) {
            self::init($params);
            foreach($params as $array_cobranza) {
                $cobranza = (object)$array_cobranza;
                $mysql = new Mysql();
                $agregar_cobranza = $mysql->executeNonQuery(
                    "CALL STP_APP_BACKUP_COBRANZAS_UNLOCK(
                        '$cobranza->idUsuario', '$cobranza->idCobranza', '$cobranza->bloqueado'
                    )"
                );
            }
            return json_encode(true);
        }

        public static function agregarUsuarioAccion($params) {
            Auth::verify();
            if(!isset($params[0]) 
                || !isset($params[1]) 
                || !isset($params[2]) 
                || count($params) == 0) {
                http_response_code(406);
                die("Parámetros de usuario incorrectos");
            }
            $id_usuario = $params[0];
            $usuario = $params[1];
            $accion = $params[2];
            $mysql = new Mysql();
            $agregar_accion = $mysql->executeNonQuery(
                "CALL STP_APP_BACKUP_ACCION_INSERT(
                    '$id_usuario', '$usuario', '$accion'
                )"
            );
            return json_encode($agregar_accion == 1);
        }

        public static function eliminarCargoAbono($params) {
            Auth::verify();
            if(!isset($params[0]) 
                || !isset($params[1]) 
                || !isset($params[2]) 
                || count($params) == 0) {
                http_response_code(406);
                die("Parámetros de cargo-abono incorrectos");
            }
            $id_usuario = $params[0];
            $id_cobranza = $params[1];
            $id_movimiento = $params[2];
            $mysql = new Mysql();
            $agregar_accion = $mysql->executeNonQuery(
                "CALL STP_APP_BACKUP_CARGOSABONOS_DELETE(
                    '$id_usuario', '$id_cobranza', '$id_movimiento'
                )"
            );
            return json_encode($agregar_accion == 1);
        }

        static function crearAppBackup($id_usuario, $usuario) {
            $encryption_key = getenv('ENCRYPTKEY');
            $esAdmin = $usuario == "ADMINISTRADOR";
            $cobranzas = array();
            $cargos_abonos = array();
            $notas = array();
            $clientes = array();
            $usuarios = array();
            $zonas = array();
            $zonas_usuarios = array();
            $inventarios = array();
            $app_backup = new stdClass();
            $mysql = new Mysql();
            $cobranzas = $mysql->executeReader(
                $esAdmin ? "CALL STP_APP_BACKUP_COBRANZAS_ADMINISTRADOR_GET('$id_usuario', '$encryption_key')"
                : "CALL STP_APP_BACKUP_COBRANZAS_COBRADOR_GET('$id_usuario', '$encryption_key', '$usuario')",
            );
            $cargos_abonos = $mysql->executeReader(
                $esAdmin ? "CALL STP_APP_BACKUP_CARGOSABONOS_ADMINISTRADOR_GET('$id_usuario')"
                : "CALL STP_APP_BACKUP_CARGOSABONOS_COBRADOR_GET('$id_usuario', '$usuario')",
            );
            $notas = $mysql->executeReader(
                $esAdmin ? "CALL STP_APP_BACKUP_NOTAS_ADMINISTRADOR_GET('$id_usuario')"
                : "CALL STP_APP_BACKUP_NOTAS_COBRADOR_GET('$id_usuario', '$usuario')",
            );
            $zonas = $mysql->executeReader(
                $esAdmin ? "CALL STP_APP_BACKUP_ZONAS_GET('$id_usuario')"
                : "CALL STP_APP_BACKUP_ZONAS_COBRADOR_GET('$id_usuario', '$usuario')",
            );
            foreach($zonas as $zona) {
                $zona->activo = $zona->activobit > 0;
            }
            $inventarios = $mysql->executeReader(
                "CALL STP_APP_BACKUP_INVENTARIOS_GET('$id_usuario', '$usuario')",
            );
            if($esAdmin) {
                $clientes = $mysql->executeReader(
                    "CALL STP_APP_BACKUP_CLIENTES_GET('$id_usuario', '$encryption_key')",
                );
                foreach($clientes as $cliente) {
                    $cliente->activo = $cliente->activobit > 0;
                }
                $usuarios = $mysql->executeReader(
                    "CALL STP_APP_BACKUP_USUARIOS_GET('$id_usuario')",
                );
                foreach($usuarios as $usuario) {
                    $usuario->activo = $usuario->estatus > 0;
                }
                $zonas_usuarios = $mysql->executeReader(
                    "CALL STP_APP_BACKUP_ZONASUSUARIOS_GET('$id_usuario')",
                );
            }
            $app_backup->cobranzas = isset($cobranzas[0]->idUsuario) ? $cobranzas : array();
            $app_backup->cargosAbonos = isset($cargos_abonos[0]->idUsuario) ? $cargos_abonos : array();
            $app_backup->notas = isset($notas[0]->idUsuario) ? $notas : array();
            $app_backup->clientes = isset($clientes[0]->idUsuario) ? $clientes : array();
            $app_backup->usuarios = isset($usuarios[0]->idUsuario) ? $usuarios : array();
            $app_backup->zonas = isset($zonas[0]->idUsuario) ? $zonas : array();
            $app_backup->zonasUsuarios = isset($zonas_usuarios[0]->idUsuario) ? $zonas_usuarios : array();
            $app_backup->inventarios = isset($inventarios[0]->idUsuario) ? $inventarios : array();
            return $app_backup;
        }
        
        static function crearAppBackupClientes($id_usuario, $clientes_lista) {
            $clientes_add = 0;
            $encryption_key = getenv('ENCRYPTKEY');
            $mysql = new Mysql();
            $restablecer_clientes = $mysql->executeNonQuery(
                "CALL STP_APP_BACKUP_CLIENTES_DELETE('$id_usuario')"
            );
            foreach($clientes_lista as $array_cliente) {
                $cliente = (object)$array_cliente;
                $activo = $cliente->activo ? 1 : 0;
                $agregar_cliente = $mysql->executeNonQuery(
                    "CALL STP_APP_BACKUP_CLIENTES_INSERT(
                        '$cliente->tabla',
                        '$cliente->idUsuario',
                        '$cliente->idCliente',
                        '$cliente->nombre',
                        '$cliente->telefono',
                        '$cliente->fechaCreacion',
                        $activo,
                        '$encryption_key'
                    )"
                );
                $clientes_add = $clientes_add + $agregar_cliente;
            }
            return $clientes_add;
        }

        static function crearAppBackupZonas($id_usuario, $zonas_lista) {
            $zonas_add = 0;
            $mysql = new Mysql();
            $restablecer_zonas = $mysql->executeNonQuery(
                "CALL STP_APP_BACKUP_ZONAS_DELETE('$id_usuario')"
            );
            foreach($zonas_lista as $array_zona) {
                $zona = (object)$array_zona;
                $activo = $zona->activo ? 1 : 0;
                $agregar_zona = $mysql->executeNonQuery(
                    "CALL STP_APP_BACKUP_ZONAS_INSERT(
                        '$zona->tabla',
                        '$zona->idUsuario',
                        '$zona->idZona',
                        '$zona->valueZona',
                        '$zona->labelZona',
                        '$zona->fechaCreacion',
                        $activo
                    )"
                );
                $zonas_add = $zonas_add + $agregar_zona;
            }
            return $zonas_add;
        }

        static function crearAppBackupZonasUsuarios($id_usuario, $zonas_usuarios_lista) {
            $zonas_usuarios_add = 0;
            $mysql = new Mysql();
            $restablecer_zonas_usuarios = $mysql->executeNonQuery(
                "CALL STP_APP_BACKUP_ZONASUSUARIOS_DELETE('$id_usuario')"
            );
            foreach($zonas_usuarios_lista as $array_zona_usuario) {
                $zona_usuario = (object)$array_zona_usuario;
                $agregar_zona = $mysql->executeNonQuery(
                    "CALL STP_APP_BACKUP_ZONASUSUARIOS_INSERT(
                        '$zona_usuario->tabla',
                        '$zona_usuario->idUsuario',
                        '$zona_usuario->idZona',
                        '$zona_usuario->usuario'
                    )"
                );
                $zonas_usuarios_add = $zonas_usuarios_add + $agregar_zona;
            }
            return $zonas_usuarios_add;
        }

        static function crearAppBackupInventarios($id_usuario, $usuario, $inventarios_lista) {
            $inventarios_add = 0;
            $encryption_key = getenv('ENCRYPTKEY');
            $mysql = new Mysql();
            $restablecer_inventarios = $mysql->executeNonQuery(
                "CALL STP_APP_BACKUP_INVENTARIOS_DELETE(
                    '$id_usuario', '$usuario'
                )"
            );
            foreach($inventarios_lista as $array_inventarios) {
                $inventario = (object)$array_inventarios;
                $agregar_inventario = $mysql->executeNonQuery(
                    "CALL STP_APP_BACKUP_INVENTARIOS_INSERT(
                        '$inventario->tabla',
                        '$inventario->idUsuario',
                        '$inventario->idArticulo',
                        '$inventario->codigoArticulo',
                        '$inventario->descripcion',
                        '$inventario->marca',
                        '$inventario->talla',
                        $inventario->precioCompra,
                        $inventario->precioVenta,
                        $inventario->existencia,
                        $inventario->maximo,
                        $inventario->minimo,
                        '$inventario->fechaCambio',
                        '$inventario->usuario'
                    )"
                );
                $inventarios_add = $inventarios_add + $agregar_inventario;
            }
            return $inventarios_add;
        }

        static function init($params) {
            Auth::verify();
            if(!isset($params[0]) || count($params) == 0) {
                http_response_code(406);
                die("Listado vacio");
            }
        }

        static function guid() {
            $guid_cadena = sprintf(
                '%04X%04X-%04X-%04X-%04X-%04X%04X%04X',
                mt_rand(0, 65535),
                mt_rand(0, 65535),
                mt_rand(0, 65535),
                mt_rand(16384, 20479),
                mt_rand(32768, 49151),
                mt_rand(0, 65535),
                mt_rand(0, 65535),
                mt_rand(0, 65535)
            );
            return $guid_cadena;   
        }
    }
?>