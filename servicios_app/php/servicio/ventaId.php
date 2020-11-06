<?php

include 'conexion.php';

$id = $_POST['id'];

    $consultar=$connect->query("SELECT * FROM venta WHERE id='".$id."'");
    $resultado=array();

    while($extraerDatos=$consultar->fetch_assoc()){
        $resultado[]=$extraerDatos;
    }

    echo json_encode($resultado);

?>