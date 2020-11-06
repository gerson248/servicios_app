<?php

 $nombre = $_POST['nombre'];
 $apellido = $_POST['apellido'];
 $email = $_POST['email'];
 $telefono = $_POST['telefono'];
 $direccion = $_POST['direccion'];
 $cuentaBancaria = $_POST['cuentaBancaria'];
 $precio = $_POST['precio'];
 $fecha = $_POST['fecha'];
 $precioconadicional = $_POST['precioconadicional'];


 $asunto = "Correo de pago";
 $code = file_get_contents("http://0.0.0.0/servicio/correoBancario.php");

 $variables = array(
    "{{nombre}}" => $nombre,
    "{{apellido}}" => $apellido,
    "{{correo}}" => $email,
    "{{telefono}}" => $telefono,
    "{{direccion}}" => $direccion,
    "{{cuentaBancaria}}" => $cuentaBancaria,
    "{{precio}}" => $precio,
    "{{fecha}}" => $fecha,
    "{{precioconadicional}}" => $precioconadicional,
);

foreach ($variables as $key => $value)
    $code = str_replace($key, $value, $code);

echo $code;

 $headers  = 'MIME-Version: 1.0' . "\r\n";
 $headers .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";

 // Additional headers
 $headers .= 'To: bot <bot@ramsesconsulting.com>' . "\r\n";
 $headers .= 'From: Reply-To <noreply@example.com>' . "\r\n";

 $correo = "gerson970707620@gmail.com";
 $mail = @mail($correo,$asunto,$code,$headers);
 echo $mail;
 if($mail) {
     echo "Enviado";
 }else{
     echo "No enviado";
 }