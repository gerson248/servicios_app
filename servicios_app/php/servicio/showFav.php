<?php

    include 'conexion.php';

    $idServicioFav=$_POST['idServicioFav'];
    $idUsuarioFav=$_POST['idUsuarioFav'];

    $consultar=$connect->query("SELECT * FROM favorito WHERE idServicioFav='".$idServicioFav."' AND idUsuarioFav='".$idUsuarioFav."'"); 
    $resultado=array();

    while($extraerDatos=$consultar->fetch_assoc()){
        $resultado[]=$extraerDatos;
    }

    echo json_encode($resultado);

?>