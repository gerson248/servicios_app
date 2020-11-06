<?php

    include 'conexion.php';

    //if(isset($_POST['email'])) { $email=$_POST['email'];
    //if(isset($_POST['password'])) { $password=$_POST['password'];
    $email=$_POST['email'];


    $consultar=$connect->query("SELECT id FROM usuario WHERE email='".$email."'"); 
    $resultado=array();

    while($extraerDatos=$consultar->fetch_assoc()){
        $resultado[]=$extraerDatos;
    }

    echo json_encode($resultado);

?>