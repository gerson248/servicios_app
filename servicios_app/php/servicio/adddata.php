<?php

	include 'conexion.php';
	
	$nombre = $_POST['nombre'];
	$apellido = $_POST['apellido'];
    $email = $_POST['email'];
	$password_hash = $_POST['password'];
	$password = password_hash($password_hash, PASSWORD_DEFAULT, ['cost' => 10]);
	$tipo = $_POST['tipo'];
	$token = $_POST['token'];
    $direccion = $_POST['direccion'];
	$telefono = $_POST['telefono'];
	$nombreimg = $_FILES['foto']['name'];
	$archivo = $_FILES['foto']['tmp_name'];
	//$foto = "images";
	$foto = "images/".$nombreimg;

	move_uploaded_file($archivo,$foto);
	
	$connect->query("INSERT INTO usuario (nombre,apellido,email,password,direccion,telefono,foto,tipo,token,confirmado) VALUES ('".$nombre."','".$apellido."','".$email."','".$password."','".$direccion."','".$telefono."','".$foto."','".$tipo."','".$token."','0')");

?>