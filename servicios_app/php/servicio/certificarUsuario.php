<?php

	include 'conexion.php';
	
    $id = $_POST['id'];

    $connect->query("UPDATE servicio SET certificado='1' WHERE id='".$id."'");

?>