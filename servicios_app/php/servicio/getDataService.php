<?php

    include 'conexion.php';
    $subcategoria=$_POST['subcategoria'];

    $consultar=$connect->query(" SELECT * FROM servicio WHERE subcategoria = '".$subcategoria."' "); 
    $resultado=array();

    while($extraerDatos=$consultar->fetch_assoc()){
        $resultado[]=$extraerDatos;
    }

    echo json_encode($resultado);

?>