<?php

    include 'conexion.php';

    $email=$_POST['email'];

    $consultar=$connect->query(" SELECT * FROM usuario WHERE email='".$email."' "); 
    $resultado=array();

    while($extraerDatos=$consultar->fetch_assoc()){
        $resultado[]=$extraerDatos;
    }

    echo json_encode($resultado);

?>