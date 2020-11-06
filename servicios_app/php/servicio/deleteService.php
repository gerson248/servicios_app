<?php

    include 'conexion.php';

    $id=$_POST['id'];


    $connect->query("DELETE FROM servicio WHERE id='".$id."'"); 

?>