<?php

 $nombre = $_POST['nombre'];
 $apellido = $_POST['apellido'];
 $email = $_POST['email'];
 $telefono = $_POST['telefono'];
 $direccion = $_POST['direccion'];
 $link_dni = $_POST['link_dni'];
 $link_recibo = $_POST['link_recibo'];
 $idProf = $_POST['idProf'];
 $servicio1 = $_POST['servicio1'];
 $idS1 = $_POST['idS1'];
 $servicio2 = $_POST['servicio2'];
 $idS2 = $_POST['idS2'];
 $servicio3 = $_POST['servicio3'];
 $idS3 = $_POST['idS3'];
 $servicio4 = $_POST['servicio4'];
 $idS4 = $_POST['idS4'];
 $servicio5 = $_POST['servicio5'];
 $idS5 = $_POST['idS5'];

 $asunto = "Correo de verificacion y certificacion de usuarios";
 $code = file_get_contents("http://192.168.1.30/servicio/email.php");

 $variables = array(
    "{{nombre}}" => $nombre,
    "{{apellido}}" => $apellido,
    "{{correo}}" => $email,
    "{{telefono}}" => $telefono,
    "{{direccion}}" => $direccion,
    "{{link_dni}}" => $link_dni,
    "{{link_recibo}}" => $link_recibo,
    "{{idProf}}" => $idProf,
    "{{servicio1}}" => $servicio1,
    "{{idS1}}" => $idS1,
    "{{servicio2}}" => $servicio2,
    "{{idS2}}" => $idS2,
    "{{servicio3}}" => $servicio3,
    "{{idS3}}" => $idS3,
    "{{servicio4}}" => $servicio4,
    "{{idS4}}" => $idS4,
    "{{servicio5}}" => $servicio5,
    "{{idS5}}" => $idS5,
);

foreach ($variables as $key => $value)
    $code = str_replace($key, $value, $code);

echo $code;

 $headers  = 'MIME-Version: 1.0' . "\r\n";
 $headers .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";

 // Additional headers
 $headers .= 'To: geerson <gerson970707620@gmail.com>' . "\r\n";
 $headers .= 'From: Reply-To <noreply@example.com>' . "\r\n";

 $mail = @mail($email,$asunto,$code,$headers);
 echo $mail;
 if($mail) {
     echo "Enviado";
 }else{
     echo "No enviado";
 }