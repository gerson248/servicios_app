<?php

    include 'conexion.php';

    //SELECT * FROM `servicio` WHERE `fechaCad` != " "
    $id=$_POST['id'];
    //$idServicioProfesional=16;

    $consultar=$connect->query("SELECT * FROM servicio WHERE fechaCad !=' '"); 
    $resultado=array();

    while($extraerDatos=$consultar->fetch_assoc()){
        $resultado[]=$extraerDatos;
    }

    echo json_encode($resultado);

?>