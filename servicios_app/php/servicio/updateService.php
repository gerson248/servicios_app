<?php

	include 'conexion.php';
	
  $categoria = $_POST['categoria'];
  $subcategoria = $_POST['subcategoria'];
  $direccion = $_POST['direccion'];
  $descripcion = $_POST['descripcion'];
  $precio = $_POST['precio'];
  $cantidad = $_POST['cantidad'];
  $porcentaje = $_POST['porcentaje'];
  $opcionA = $_POST['opcionA'];
  $opcionB = $_POST['opcionB'];
  $fechaCad = $_POST['fechaCad'];
  $id=$_POST['id'];
    
    move_uploaded_file($file,$archivo);   

    if($precio == null){
        print("todos los datos menos precio");
        $connect->query("UPDATE servicio SET precio = '0',categoria = '".$categoria."',subcategoria = '".$subcategoria."',direccion = '".$direccion."',descripcion = '".$descripcion."',opcionA = '".$opcionA."',opcionB = '".$opcionB."' WHERE id = '".$id."' ");
        //$connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,latitud,longitud) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$latitud."','".$longitud."')");
      }else{
        if($cantidad == null && $porcentaje == null){
          print("todos los datos con precio");
          $connect->query("UPDATE servicio SET porcentaje='0', cantidad='0', categoria = '".$categoria."',subcategoria = '".$subcategoria."',direccion = '".$direccion."',descripcion = '".$descripcion."',precio = '".$precio."',opcionA = '".$opcionA."',opcionB = '".$opcionB."' WHERE id = '".$id."' ");
          //$connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,precio,latitud,longitud) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$precio."','".$latitud."','".$longitud."')");
        }else{
          if ($porcentaje != null) {
            print("todos los datos con porcentaje");
            $connect->query("UPDATE servicio SET cantidad='0', categoria = '".$categoria."',subcategoria = '".$subcategoria."',direccion = '".$direccion."',descripcion = '".$descripcion."',precio = '".$precio."',porcentaje = '".$porcentaje."',fechaCad = '".$fechaCad."',opcionA = '".$opcionA."',opcionB = '".$opcionB."' WHERE id = '".$id."' ");
            //$connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,precio,porcentaje,latitud,longitud) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$precio."','".$porcentaje."','".$latitud."','".$longitud."')");
          } else {
            print("todo los datos con cantidad");
            $connect->query("UPDATE servicio SET porcentaje='0', categoria = '".$categoria."',subcategoria = '".$subcategoria."',direccion = '".$direccion."',descripcion = '".$descripcion."',precio = '".$precio."',cantidad = '".$cantidad."',fechaCad = '".$fechaCad."',opcionA = '".$opcionA."',opcionB = '".$opcionB."' WHERE id = '".$id."' ");
            //$connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,precio,cantidad,latitud,longitud) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$precio."','".$cantidad."','".$latitud."','".$longitud."')");
 
          }
        }
      }
?>

