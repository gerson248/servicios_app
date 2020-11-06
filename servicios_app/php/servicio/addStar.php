<?php

	include 'conexion.php';
	
    $calificar = $_POST['calificar'];
    $id = $_POST['id'];

    $connect->query("UPDATE venta SET calificar='".$calificar."' WHERE id='".$id."'");

?>