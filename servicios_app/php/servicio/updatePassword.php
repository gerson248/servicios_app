<?php

	include 'conexion.php';
	
    $email = $_POST['email'];
    $password = $_POST['password'];

	
	$connect->query("UPDATE usuario SET password='".$password."' WHERE email='".$email."'");

?>