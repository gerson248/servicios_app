<?php

	include 'conexion.php';
	
    $id = $_POST['id'];

    $connect->query("UPDATE profesional SET verificado='1' WHERE id='".$id."'");

?>