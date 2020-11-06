<?php

    include 'conexion.php';

    $idServicioProfesional=$_POST['idServicioProfesional'];

    $consultar=$connect->query("SELECT * FROM profesional WHERE id='".$idServicioProfesional."'"); 
    $resultado=array();

    while($extraerDatos=$consultar->fetch_assoc()){
        $resultado[]=$extraerDatos;
    }

    echo json_encode($resultado);

?>