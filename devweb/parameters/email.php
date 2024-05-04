<?php
    Class Email {
        function __construct() { }

        public static function enviar() {
            $para  = 'manuel_trujillo@ucol.mx';

            $título = 'Recordatorio de cumpleaños para Agosto';

            $mensaje = '
            <html>
            <head>
            <title>Recordatorio de cumpleaños para Agosto</title>
            </head>
            <body>
            <p>¡Estos son los cumpleaños para Agosto!</p>
            <table>
                <tr>
                <th>Quien</th><th>Día</th><th>Mes</th><th>Año</th>
                </tr>
                <tr>
                <td>Joe</td><td>3</td><td>Agosto</td><td>1970</td>
                </tr>
                <tr>
                <td>Sally</td><td>17</td><td>Agosto</td><td>1973</td>
                </tr>
            </table>
            </body>
            </html>
            ';

            $cabeceras  = 'MIME-Version: 1.0' . "\r\n";
            $cabeceras .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
            $cabeceras .= 'To: Usuario <manuel_trujillo@ucol.mx>' . "\r\n";
            $cabeceras .= 'From: Sistema Soporte <qa8mj2g5h2om@appchop.com>' . "\r\n";
            
            return mail($para, $título, $mensaje, $cabeceras);
        }
    }
?>