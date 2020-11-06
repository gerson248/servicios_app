<?php

include 'conexion.php';

$idUsuarioProfesional = $_POST['idUsuarioProfesional'];
        
        $consultar=$connect->query("SELECT * FROM venta WHERE idUsuarioProfesional='".$idUsuarioProfesional."' "); 
        $resultado=array();
    
        while($extraerDatos=$consultar->fetch_assoc()){
            $resultado[]=$extraerDatos;
        }
    
        echo json_encode($resultado);

?>