<?php

	include 'conexion.php';
	
	$idClienteUsuario = $_POST['idClienteUsuario'];

	
	$connect->query("INSERT INTO cliente (idClienteUsuario) VALUES ('".$idClienteUsuario."')");

?>