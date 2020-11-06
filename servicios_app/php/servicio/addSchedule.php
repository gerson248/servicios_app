<?php

    include 'conexion.php';

    $id=$_POST['id'];
    $dias=$_POST['dias'];
    $horario=$_POST['horario'];


    $consultar=$connect->query("UPDATE servicio SET dias ='".$dias."' WHERE id ='".$id."' "); 
    $consultar1=$connect->query("UPDATE servicio SET horario ='".$horario."' WHERE id ='".$id."' "); 


?>