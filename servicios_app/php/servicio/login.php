<?php

    include 'conexion.php';

    //if(isset($_POST['email'])) { $email=$_POST['email'];
    //if(isset($_POST['password'])) { $password=$_POST['password'];
    //$passwordhash='$2y$10$iurOF5OPLNAazrs5cH.mkeChPB7NJliLawMrwy9poAi7GGuEXdNPC';
    $password=$_POST['password'];
    $email=$_POST['email'];

    $variables = $connect->query("SELECT * FROM usuario WHERE email='".$email."'");
    $user = mysqli_fetch_assoc($variables);

    $passwordhash=$user['password'];
    

    if(password_verify($password,$passwordhash)){
        echo "CORRECTO";
    }
?>