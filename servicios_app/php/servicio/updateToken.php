<?php

	include 'conexion.php';
	
    $token = $_POST['token'];
    $email = $_POST['email'];

    $connect->query("UPDATE usuario SET token='".$token."' WHERE email='".$email."'");

?>