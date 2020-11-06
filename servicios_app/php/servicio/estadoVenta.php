<?php

	include 'conexion.php';
	
    $idVenta = $_POST['idVenta'];
	
    $connect->query("UPDATE venta SET estado='".$estado."' WHERE id='".$idVenta."' ");

?>