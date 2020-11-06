<?php

    include 'conexion.php';

    //if(isset($_POST['email'])) { $email=$_POST['email'];
    //if(isset($_POST['password'])) { $password=$_POST['password'];
    $idServicioProfesional=$_POST['idServicioProfesional'];
    //$idServicioProfesional=16;

    $consultar=$connect->query("SELECT * FROM servicio WHERE idServicioProfesional='".$idServicioProfesional."'"); 
    $resultado=array();

    while($extraerDatos=$consultar->fetch_assoc()){
        $resultado[]=$extraerDatos;
    }

    echo json_encode($resultado);

?>