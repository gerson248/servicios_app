<?php

	include 'conexion.php';
	
	$email = $_POST['email'];

	
	$connect->query("UPDATE usuario SET confirmado='1' WHERE email='".$email."'");

?>