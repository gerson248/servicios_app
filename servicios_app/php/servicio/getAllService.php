<?php

    include 'conexion.php';
    $n=$_POST['n'];

    $consultar=$connect->query(" SELECT * FROM servicio "); 
    $resultado=array();

    while($extraerDatos=$consultar->fetch_assoc()){
        $resultado[]=$extraerDatos;
    }

    echo json_encode($resultado);

?>