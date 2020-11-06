<?php

	include 'conexion.php';
	
    $email = $_POST['email'];
    $direccion = $_POST['direccion'];
    $telefono = $_POST['telefono'];

	
    $connect->query("UPDATE usuario SET direccion='".$direccion."' WHERE email='".$email."'");
    $connect->query("UPDATE usuario SET telefono='".$telefono."' WHERE email='".$email."'");

?>