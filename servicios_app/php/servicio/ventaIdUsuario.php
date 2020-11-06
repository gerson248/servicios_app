<?php

	include 'conexion.php';
	
	$idServicio = $_POST['idServicio'];

    $consultar=$connect->query("SELECT * FROM venta WHERE idServicio='".$idServicio."'"); 
    $resultado=array();

    while($extraerDatos=$consultar->fetch_assoc()){
        $resultado[]=$extraerDatos;
    }

    echo json_encode($resultado);

?>