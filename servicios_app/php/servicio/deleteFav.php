<?php

	include 'conexion.php';
	
	$idServicioFav = $_POST['idServicioFav'];
	$idUsuarioFav = $_POST['idUsuarioFav'];

	
	$connect->query("DELETE FROM favorito WHERE idServicioFav='".$idServicioFav."' AND idUsuarioFav='".$idUsuarioFav."'");
?>