<?php

	include 'conexion.php';
	
    $id=$_POST['id'];

    $nombrearch = $_FILES['archivo']['name'];
    $file = $_FILES['archivo']['tmp_name']; 

    $archivo = "certificadoServicio/".$nombrearch;
    
    move_uploaded_file($file,$archivo);

    $connect->query("UPDATE servicio SET archivo = '".$archivo."' WHERE id = '".$id."' ");
    
?>

