<?php

	include 'conexion.php';
	
    $idProfesionalUsuario = $_POST['idProfesionalUsuario'];
    $cuentaBancaria = $_POST['cuentaBancaria'];
    $online = $_POST['online'];

	
    $connect->query("UPDATE profesional SET cuentaBancaria='".$cuentaBancaria."', online='".$online."' WHERE idProfesionalUsuario='".$idProfesionalUsuario."'");

?>