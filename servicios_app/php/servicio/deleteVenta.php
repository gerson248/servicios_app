<?php

    include 'conexion.php';

	$idServicio = $_POST['idServicio'];
	$estado = $_POST['estado'];


    $connect->query("DELETE FROM venta WHERE idServicio='".$idServicio."' AND estado='".$estado."'");

?>