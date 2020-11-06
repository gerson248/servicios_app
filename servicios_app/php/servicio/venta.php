<?php

	include 'conexion.php';
	
	$idUsuario = $_POST['idUsuario'];
    $idServicio = $_POST['idServicio'];
	$idUsuarioProfesional = $_POST['idUsuarioProfesional'];
	$dia = $_POST['dia'];
	$calificar='0';
	$recomendar='0';
	$estado='0';

    $connect->query("INSERT INTO venta (idUsuario,idServicio,dia,idUsuarioProfesional,calificar,recomendar,estado) VALUES ('".$idUsuario."','".$idServicio."','".$dia."','".$idUsuarioProfesional."','".$calificar."','".$recomendar."','".$estado."')");

?>