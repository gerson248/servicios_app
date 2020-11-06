<?php

	include 'conexion.php';
	
    $id = $_POST['id'];

    $latitud = $_POST['latitud'];
    $longitud = $_POST['longitud'];

    $connect->query("UPDATE servicio SET latitud = '".$latitud."',longitud = '".$longitud."' WHERE id = '".$id."' ");

?>

