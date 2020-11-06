<?php

	include 'conexion.php';
	
    $tipo = $_POST['tipo'];
    $id = $_POST['id'];

    //$nombrearchivo1 = $_FILES['dni']['name'];
    $temp = explode(".", $_FILES["dni"]["name"]); 
    $nombrearchivo1 = round(microtime(true)) . '.' . end($temp);
    $archivo1 = $_FILES['dni']['tmp_name'];
    //$foto = "images";
    $dni = "archivos/".$nombrearchivo1;
  
    move_uploaded_file($archivo1,$dni);

    $nombrearchivo2 = $_FILES['recibo']['name'];
    $archivo2 = $_FILES['recibo']['tmp_name'];
    //$foto = "images";
    $recibo = "archivos/".$nombrearchivo2;
  
    move_uploaded_file($archivo2,$recibo);

    if($tipo=="DNI"){
        $connect->query("UPDATE profesional SET dni='".$dni."' WHERE idProfesionalUsuario='".$id."'");
    }else{
        if($tipo=="recibo"){
            $connect->query("UPDATE profesional SET recibo='".$recibo."' WHERE idProfesionalUsuario='".$id."'");
        }
    }

?>