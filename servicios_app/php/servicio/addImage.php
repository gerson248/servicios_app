<?php

	include 'conexion.php';
	
    $id = $_POST['id'];

    
    $nombregal1 = $_FILES['galeria1']['name'];
    $archivo1 = $_FILES['galeria1']['tmp_name'];
    //$foto = "images";
    $galeria1 = "galeria/".$nombregal1;
  
    move_uploaded_file($archivo1,$galeria1);

    $nombregal2 = $_FILES['galeria2']['name'];
    $archivo2 = $_FILES['galeria2']['tmp_name'];
    //$foto = "images";
    $galeria2 = "galeria/".$nombregal2;
  
    move_uploaded_file($archivo2,$galeria2);

    $nombregal3 = $_FILES['galeria3']['name'];
    $archivo3 = $_FILES['galeria3']['tmp_name'];
    //$foto = "images";
    $galeria3 = "galeria/".$nombregal3;
  
    move_uploaded_file($archivo3,$galeria3);

        if($archivo1!=null && $archivo2==null && $archivo3==null){
          //imagen 1 disponible
          $connect->query("UPDATE servicio SET galeria1 = '".$galeria1."' WHERE id = '".$id."' ");

        }else{
          if($archivo1==null && $archivo2!=null && $archivo3==null){
            //imagen 2 disponible
            $connect->query("UPDATE servicio SET galeria2 = '".$galeria2."' WHERE id = '".$id."' ");
          }else{
            if($archivo1==null && $archivo2==null && $archivo3!=null){
              //imagen 3 disponible
              $connect->query("UPDATE servicio SET galeria3 = '".$galeria3."' WHERE id = '".$id."' ");
            }else{
              if($archivo1!=null && $archivo2!=null && $archivo3==null){
                //imagen 1 y 2 disponible
                $connect->query("UPDATE servicio SET galeria1 = '".$galeria1."', galeria2 = '".$galeria2."' WHERE id = '".$id."' ");
              }else{
                if($archivo1==null && $archivo2!=null && $archivo3!=null){
                  //imagen 2 y 3 disponible
                  $connect->query("UPDATE servicio SET galeria3 = '".$galeria3."', galeria2 = '".$galeria2."' WHERE id = '".$id."' ");
                }else{
                  if($archivo1!=null && $archivo2==null && $archivo3!=null){
                    //imagen 1 y 3 disponible
                    $connect->query("UPDATE servicio SET galeria3 = '".$galeria3."', galeria1 = '".$galeria1."' WHERE id = '".$id."' ");
                  }else{
                    if($archivo1!=null && $archivo2!=null && $archivo3!=null){
                      //imagen 1 2 y 3 disponible
                      $connect->query("UPDATE servicio SET galeria2 = '".$galeria2."', galeria3 = '".$galeria3."', galeria1 = '".$galeria1."' WHERE id = '".$id."' ");
                    }
                }
              }
            }
          }
        }
      }
?>