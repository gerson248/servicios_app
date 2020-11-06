<?php

	include 'conexion.php';
	
	$idServicioFav = $_POST['idServicioFav'];
	$idUsuarioFav = $_POST['idUsuarioFav'];
	$idServicioProfesionalFav = $_POST['idServicioProfesionalFav'];

	
	$connect->query("INSERT INTO favorito (idServicioFav,idUsuarioFav,idServicioProfesionalFav) VALUES ('".$idServicioFav."','".$idUsuarioFav."','".$idServicioProfesionalFav."')");

?>