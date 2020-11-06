<?php

	include 'conexion.php';
	
	$idServicio = $_POST['idServicio'];
	$estado = $_POST['estado'];

    $consultar=$connect->query("SELECT * FROM venta WHERE idServicio='".$idServicio."' and estado='".$estado."'"); 
    $resultado=array();

    while($extraerDatos=$consultar->fetch_assoc()){
        $resultado[]=$extraerDatos;
    }

    echo json_encode($resultado);

?>