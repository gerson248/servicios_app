<?php
 
 //$asunto = $_POST['asunto'];
 $code = $_POST['code'];
 $email = $_POST['email'];
 $asunto = "Codigo de verificacion";
 //$code = "1234";
 //$email = "gerson_25_99@hotmail.com";
 $header = "From: noreply@example.com" . "\r\n";
 $header.= "Reply-To: noreply@example.com" . "\r\n";
 $header.= "X-Mailer: PHP/". phpversion();
 $mail = @mail($email,$asunto,$code,$header);
 if($mail) {
     echo "Enviado";
 }else{
     echo "No enviado";
 }