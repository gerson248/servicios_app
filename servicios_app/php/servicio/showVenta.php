<?php

include 'conexion.php';

$idUsuario = $_POST['idUsuario'];
        
        $consultar=$connect->query("SELECT * FROM venta WHERE idUsuario='".$idUsuario."'"); 
        $resultado=array();
    
        while($extraerDatos=$consultar->fetch_assoc()){
            $resultado[]=$extraerDatos;
        }
    
        echo json_encode($resultado);

?>