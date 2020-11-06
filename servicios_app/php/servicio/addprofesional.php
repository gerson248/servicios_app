<?php

	include 'conexion.php';
	
	$idProfesionalUsuario = $_POST['idProfesionalUsuario'];

	
	$connect->query("INSERT INTO profesional (idProfesionalUsuario) VALUES ('".$idProfesionalUsuario."')");

?>