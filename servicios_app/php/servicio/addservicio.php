<?php

	include 'conexion.php';
	
    $categoria = $_POST['categoria'];
    $subcategoria = $_POST['subcategoria'];
    $direccion = $_POST['direccion'];
    $opcionA = $_POST['opcionA'];
    $opcionB = $_POST['opcionB'];
    $descripcion = $_POST['descripcion'];
    $precio = $_POST['precio'];
    $cantidad = $_POST['cantidad'];
    $porcentaje = $_POST['porcentaje'];
    $fechaCad = $_POST['fechaCad'];

    $archivo = '';
    $galeria1 = '0';
    $galeria2 = '0';
    $galeria3 = '0';
    $recomendar = '0';
    $latitud = '0';
    $longitud = '0';
    $dias = '0';
    $horario = '0';

    $idServicioProfesional=$_POST['idServicioProfesional'];

    /*opcionA = '0'
    opcionB = '0'
    precio='0'
    cantidad = '0'
    porcentaje = '0'*/

    //,archivo,galeria1,galeria2,galeria3,recomendar,latitud,longitud,dias,horario
    //'".$archivo."','".$galeria1."','".$galeria2."','".$galeria3."', '".$recomendar."','".$latitud."','".$longitud."','".$dias."','".$horario."'

    if($precio == null){
        print("todos los datos menos precio");
        if ($opcionA!=null && $opcionB==null) {
          $connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,opcionA,idServicioProfesional,archivo,galeria1,galeria2,galeria3,recomendar,latitud,longitud,dias,horario,precio,cantidad,porcentaje,opcionB) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."', '".$opcionA."','".$idServicioProfesional."','".$archivo."','".$galeria1."','".$galeria2."','".$galeria3."', '".$recomendar."','".$latitud."','".$longitud."','".$dias."','".$horario."','0','0','0','0')");
          //$connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,latitud,longitud,opcionA) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$latitud."','".$longitud."', '".$opcionA."')");
        } else {
          if ($opcionB!=null && $opcionA==null) {
            $connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,opcionB,idServicioProfesional,archivo,galeria1,galeria2,galeria3,recomendar,latitud,longitud,dias,horario,precio,cantidad,porcentaje,opcionA) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."', '".$opcionB."','".$idServicioProfesional."','".$archivo."','".$galeria1."','".$galeria2."','".$galeria3."', '".$recomendar."','".$latitud."','".$longitud."','".$dias."','".$horario."','0','0','0','0')");
            //$connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,latitud,longitud,opcionB) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$latitud."','".$longitud."', '".$opcionB."')");
          } else {
            if ($opcionA!=null && $opcionB!=null) {
              $connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,opcionA,opcionB,idServicioProfesional,archivo,galeria1,galeria2,galeria3,recomendar,latitud,longitud,dias,horario,precio,cantidad,porcentaje) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."', '".$opcionA."', '".$opcionB."','".$idServicioProfesional."','".$archivo."','".$galeria1."','".$galeria2."','".$galeria3."', '".$recomendar."','".$latitud."','".$longitud."','".$dias."','".$horario."','0','0','0')");
              //$connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,latitud,longitud,opcionA,opcionB) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$latitud."','".$longitud."', '".$opcionA."', '".$opcionB."')");
            } else {
              $connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,idServicioProfesional,archivo,galeria1,galeria2,galeria3,recomendar,latitud,longitud,dias,horario,precio,cantidad,porcentaje,opcionA,opcionB) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$idServicioProfesional."','".$archivo."','".$galeria1."','".$galeria2."','".$galeria3."', '".$recomendar."','".$latitud."','".$longitud."','".$dias."','".$horario."','0','0','0','0','0')");

              //$connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,latitud,longitud) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$latitud."','".$longitud."')");
            }
          }
        }
        //$connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,latitud,longitud) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$latitud."','".$longitud."')");
      }else{
        if($cantidad == null && $porcentaje == null){
          print("todos los datos con precio");
          if ($opcionA!=null && $opcionB==null) {
            $connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,precio,opcionA,idServicioProfesional,archivo,galeria1,galeria2,galeria3,recomendar,latitud,longitud,dias,horario,cantidad,porcentaje,opcionB) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$precio."', '".$opcionA."','".$idServicioProfesional."','".$archivo."','".$galeria1."','".$galeria2."','".$galeria3."', '".$recomendar."','".$latitud."','".$longitud."','".$dias."','".$horario."','0','0','0')");

            //$connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,precio,latitud,longitud,opcionA) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$precio."','".$latitud."','".$longitud."', '".$opcionA."')");
          } else {
            if ($opcionB!=null && $opcionA==null) {
              $connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,precio,opcionB,idServicioProfesional,archivo,galeria1,galeria2,galeria3,recomendar,latitud,longitud,dias,horario,cantidad,porcentaje,opcionA) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$precio."', '".$opcionB."','".$idServicioProfesional."','".$archivo."','".$galeria1."','".$galeria2."','".$galeria3."', '".$recomendar."','".$latitud."','".$longitud."','".$dias."','".$horario."','0','0','0')");

              //$connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,precio,latitud,longitud,opcionB) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$precio."','".$latitud."','".$longitud."', '".$opcionB."')");
            } else {
              if ($opcionA!=null && $opcionB!=null) {
                $connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,precio,opcionA,opcionB,idServicioProfesional,archivo,galeria1,galeria2,galeria3,recomendar,latitud,longitud,dias,horario,cantidad,porcentaje) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$precio."', '".$opcionA."', '".$opcionB."','".$idServicioProfesional."','".$archivo."','".$galeria1."','".$galeria2."','".$galeria3."', '".$recomendar."','".$latitud."','".$longitud."','".$dias."','".$horario."','0','0')");

                //$connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,precio,latitud,longitud,opcionA,opcionB) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$precio."','".$latitud."','".$longitud."', '".$opcionA."', '".$opcionB."')");
              } else {
                $connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,precio,idServicioProfesional,archivo,galeria1,galeria2,galeria3,recomendar,latitud,longitud,dias,horario,cantidad,porcentaje,opcionA,opcionB) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$precio."','".$idServicioProfesional."','".$archivo."','".$galeria1."','".$galeria2."','".$galeria3."', '".$recomendar."','".$latitud."','".$longitud."','".$dias."','".$horario."','0','0','0','0')");

                //$connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,precio,latitud,longitud) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$precio."','".$latitud."','".$longitud."')");
              }
            }
          }
          //$connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,precio,latitud,longitud) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$precio."','".$latitud."','".$longitud."')");
        }else{
          if ($porcentaje != null) {
            print("todos los datos con porcentaje");
            if ($opcionA!=null && $opcionB==null) {
              $connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,precio,porcentaje,opcionA,fechaCad,idServicioProfesional,archivo,galeria1,galeria2,galeria3,recomendar,latitud,longitud,dias,horario,cantidad,opcionB) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$precio."','".$porcentaje."', '".$opcionA."','".$fechaCad."','".$idServicioProfesional."','".$archivo."','".$galeria1."','".$galeria2."','".$galeria3."', '".$recomendar."','".$latitud."','".$longitud."','".$dias."','".$horario."','0','0')");

              //$connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,precio,porcentaje,latitud,longitud,opcionA) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$precio."','".$porcentaje."','".$latitud."','".$longitud."', '".$opcionA."')");
            } else {
              if ($opcionB!=null && $opcionA==null) {
                $connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,precio,porcentaje,opcionB,fechaCad,idServicioProfesional,archivo,galeria1,galeria2,galeria3,recomendar,latitud,longitud,dias,horario,cantidad,opcionA) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$precio."','".$porcentaje."', '".$opcionB."','".$fechaCad."','".$idServicioProfesional."','".$archivo."','".$galeria1."','".$galeria2."','".$galeria3."', '".$recomendar."','".$latitud."','".$longitud."','".$dias."','".$horario."','0','0')");

                //$connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,precio,porcentaje,latitud,longitud,opcionB) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$precio."','".$porcentaje."','".$latitud."','".$longitud."', '".$opcionB."')");
              } else {
                if ($opcionA!=null && $opcionB!=null) {
                  $connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,precio,porcentaje,opcionA,opcionB,fechaCad,idServicioProfesional,archivo,galeria1,galeria2,galeria3,recomendar,latitud,longitud,dias,horario,cantidad) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$precio."','".$porcentaje."', '".$opcionA."', '".$opcionB."','".$fechaCad."','".$idServicioProfesional."','".$archivo."','".$galeria1."','".$galeria2."','".$galeria3."', '".$recomendar."','".$latitud."','".$longitud."','".$dias."','".$horario."','0')");

                  //$connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,precio,porcentaje,latitud,longitud,opcionA,opcionB) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$precio."','".$porcentaje."','".$latitud."','".$longitud."', '".$opcionA."', '".$opcionB."')");
                } else {
                  $connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,precio,porcentaje,fechaCad,idServicioProfesional,archivo,galeria1,galeria2,galeria3,recomendar,latitud,longitud,dias,horario,cantidad,opcionA,opcionB) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$precio."','".$porcentaje."','".$fechaCad."','".$idServicioProfesional."','".$archivo."','".$galeria1."','".$galeria2."','".$galeria3."', '".$recomendar."','".$latitud."','".$longitud."','".$dias."','".$horario."','0','0','0')");

                  //$connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,precio,porcentaje,latitud,longitud) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$precio."','".$porcentaje."','".$latitud."','".$longitud."')");
                }
              }
            }
            //$connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,precio,porcentaje,latitud,longitud) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$precio."','".$porcentaje."','".$latitud."','".$longitud."')");
          } else {
            print("todo los datos con cantidad");
            if ($opcionA!=null && $opcionB==null) {
              $connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,precio,cantidad,opcionA,fechaCad,idServicioProfesional,archivo,galeria1,galeria2,galeria3,recomendar,latitud,longitud,dias,horario,porcentaje,opcionB) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$precio."','".$cantidad."', '".$opcionA."','".$fechaCad."','".$idServicioProfesional."','".$archivo."','".$galeria1."','".$galeria2."','".$galeria3."', '".$recomendar."','".$latitud."','".$longitud."','".$dias."','".$horario."','0','0')");

              //$connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,precio,cantidad,latitud,longitud,opcionA) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$precio."','".$cantidad."','".$latitud."','".$longitud."', '".$opcionA."')");
            } else {
              if ($opcionB!=null && $opcionA==null) {
                $connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,precio,cantidad,opcionB,fechaCad,idServicioProfesional,archivo,galeria1,galeria2,galeria3,recomendar,latitud,longitud,dias,horario,porcentaje,opcionA) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$precio."','".$cantidad."', '".$opcionB."','".$fechaCad."','".$idServicioProfesional."','".$archivo."','".$galeria1."','".$galeria2."','".$galeria3."', '".$recomendar."','".$latitud."','".$longitud."','".$dias."','".$horario."','0','0')");

                //$connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,precio,cantidad,latitud,longitud,opcionB) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$precio."','".$cantidad."','".$latitud."','".$longitud."', '".$opcionB."')");
              } else {
                if ($opcionA!=null && $opcionB!=null) {
                  $connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,precio,cantidad,opcionA,opcionB,fechaCad,idServicioProfesional,archivo,galeria1,galeria2,galeria3,recomendar,latitud,longitud,dias,horario,porcentaje) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$precio."','".$cantidad."', '".$opcionA."', '".$opcionB."','".$fechaCad."','".$idServicioProfesional."','".$archivo."','".$galeria1."','".$galeria2."','".$galeria3."', '".$recomendar."','".$latitud."','".$longitud."','".$dias."','".$horario."','0')");

                  //$connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,precio,cantidad,latitud,longitud,opcionA,opcionB) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$precio."','".$cantidad."','".$latitud."','".$longitud."', '".$opcionA."', '".$opcionB."')");
                } else {
                  $connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,precio,cantidad,fechaCad,idServicioProfesional,archivo,galeria1,galeria2,galeria3,recomendar,latitud,longitud,dias,horario,porcentaje,opcionA,opcionB) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$precio."','".$cantidad."','".$fechaCad."','".$idServicioProfesional."','".$archivo."','".$galeria1."','".$galeria2."','".$galeria3."', '".$recomendar."','".$latitud."','".$longitud."','".$dias."','".$horario."','0','0','0')");

                  //$connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,precio,cantidad,latitud,longitud) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$precio."','".$cantidad."','".$latitud."','".$longitud."')");
                }
              }
            }
            //$connect->query("INSERT INTO servicio (categoria,subcategoria,direccion,descripcion,precio,cantidad,latitud,longitud) VALUES ('".$categoria."','".$subcategoria."','".$direccion."','".$descripcion."','".$precio."','".$cantidad."','".$latitud."','".$longitud."')");
 
          }
        }
      }
?>

