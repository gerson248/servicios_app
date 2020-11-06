<?php

$connect = new mysqli("localhost","root","","servicio");

if($connect){
	 
}else{
	echo "Fallo, revise ip o firewall";
	exit();
}