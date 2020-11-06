<?php

	include 'conexion.php';
	
    $recomendar = $_POST['recomendar'];
    $idServicio = $_POST['idServicio'];
    $idUsuario = $_POST['idUsuario'];

	$connect->query("UPDATE venta SET recomendar='".$recomendar."' WHERE idUsuario='".$idUsuario."' AND idServicio='".$idServicio."'");

?>