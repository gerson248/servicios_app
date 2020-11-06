<?php

    include 'conexion.php';
    $idUsuarioFav=$_POST['idUsuarioFav'];

    $consultar=$connect->query(" SELECT * FROM favorito WHERE idUsuarioFav = '".$idUsuarioFav."' "); 
    $resultado=array();

    while($extraerDatos=$consultar->fetch_assoc()){
        $resultado[]=$extraerDatos;
    }

    echo json_encode($resultado);

?>