<?php

    include 'conexion.php';

    $idServicio=$_POST['idServicio'];
    $idUsuario=$_POST['idUsuario'];

    $consultar=$connect->query("SELECT * FROM venta WHERE idUsuario='".$idUsuario."' AND idServicio='".$idServicio."'"); 
    $resultado=array();

    while($extraerDatos=$consultar->fetch_assoc()){
        $resultado[]=$extraerDatos;
    }

    echo json_encode($resultado);

?>