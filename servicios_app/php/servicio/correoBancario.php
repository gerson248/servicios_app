<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <style type="text/css">
:root{
    --green-color:#7ACC2D;
    --white-color: white;
    --black-color:black;
    /*tipografia*/
    --normal:12px;
    /*Espaciado*/
    --space: 10px;
    /*box shadow*/
    --box:3px 1px 1px #848080;
}
html,body{
    width: 100%;
    padding: 0px;
    margin: 0px;
    font-size: var(--normal);
    font-family: Helvetica;/*tipo de letra*/
}

nav{
    display: flex;/*para que no se posicione uno debajo del otro si no al costado*/
    background-color:var(--green-color);
    padding: var(--space);
    color: var(--white-color);
    justify-content: space-between;/*lo posiciona todo a la derecha*/
    align-items: center;/* Para alinear todos los elementos en el centro*/
}

nav ul{
    display: flex;/*para que no se posicione uno debajo del otro si no al costado*/
}

nav li{
    padding-left: 20px;/*lo posiciona a la derecha*/
    list-style: none;/*quita los puntos(vinietas)*/
}

nav li a{
    color: var(--black-color);
    text-decoration: none;/*quita el subrayado*/ 
    
}

/*acciones puede tener un boton*/
nav li a:hover{
    color: var(--white-color);/*cuando pasemos o demos click con el mouse se vuelva balnco*/
}

/*------------- Main section----*/

.main_section{
    padding: 20%;
    text-align: center;/* para alinear al centro*/
}

.products{
    /*background-image: url("../images/curve.png");/* los 2 puntos me indica retroceso de la carpeta */
    /*padding: 20%;/* Mientras ams ppading se ahce mas chico se pone los productos*/
    /*background-position: center top;/* para manejar su posicion se alineara hacia el centro y (top) hacia arriba*/
    /*background-repeat: no-repeat;*/
    /*height: 95px;/*para darle altura (mno usar max height que luego apra usar digamos un css de mobile este se amtniene en su tamaño )*/
    display: flex;/*para poner al costado el contenido uno de otro*/
    /*background-size: cover;/*para que ocupe el tamaño del div que tiene*/
}
.product{
    padding:  var(--space);/*para seaprar los productos 10 px uno del otro*/
    /*margin-top: -240px;*/
}
.product .content{
    background-color: var(--white-color);
    padding: 15px;/*para aumentar el tamaño del recuadro blanco contenido*/
    box-shadow: var(--box);/* esto nos ayuda a crear sombras*/
}

.img_content{
    text-align: center;
}

.main_button{
    background-color: #7ACC2D;
    width: 100%;/*para que ocupe todo el espaciod e la tarjeta*/
    padding:  var(--space);
    font-size: 17px;/*aumenta el tamaño*/
    color: var(--white-color);
    border: 0;/*le quitamos el borde*/
    cursor: pointer;/*esto dirve para qeu cuando apsemos por el boton salga la manita*/
    border-radius: 3px;
}

.main_button_main{
    background-color: #e92121;
    width: 100%;/*para que ocupe todo el espaciod e la tarjeta*/
    padding:  var(--space);
    font-size: 17px;/*aumenta el tamaño*/
    color: var(--white-color);
    border: 0;/*le quitamos el borde*/
    cursor: pointer;/*esto dirve para qeu cuando apsemos por el boton salga la manita*/
    border-radius: 3px;
}



.main_button:hover{
    background-color: #6fb32f;
}

    </style>
	<title>email</title>
</head>
<body style="background-color: black ">

<!--Copia desde aquí-->
<table style="max-width: 600px; padding: 10px; margin:0 auto; border-collapse: collapse;">
	<tr>
		<td style="background-color: #ecf0f1; text-align: left; padding: 0">
			<a href="http://www.ramsesconsulting.com">
				<img width="15%" style="display:block; margin: 0% 0%" src="http://0.0.0.0/servicio/imgCorreo/escudo.png">
			</a>
		</td>
	</tr>
	
	<tr>
		<td style="background-color: #ecf0f1">
			<div style="color: #34495e; margin: 4% 10% 2%; text-align: justify;font-family: sans-serif">
				<h2 style="color: #e67e22; margin: 0 0 7px">Ramses Consulting</h2>
				<p style="margin: 2px; font-size: 15px">
					Datos del profesional {{nombre}} {{apellido}} el cual se le contrato un servicio haciendo el uso ed metodo pago online:</p>
				<ul style="font-size: 15px;  margin: 10px 0">
					<li>Numero de telefono: {{telefono}}.</li>
					<li>Correo electronico: {{correo}}.</li>
					<li>Direccion: {{direccion}}.</li>
					<li>Cuenta Bancaria: {{cuentaBancaria}}.</li>
                    <li>Monto neto a depositar: {{precio}}.</li>
                    <li>Fecha de deposito: {{fecha}}.</li>
				</ul>
                <div style="width: 100%; text-align: center; margin: 0 0 0; color:#494d50;"><h3>Datos del profesional</h3></div>
				<p style="color: #b3b3b3; font-size: 12px; text-align: center;margin: 30px 0 0">Ramses Consulting 2020</p>
			</div>
		</td>
	</tr>
</table>
<!--hasta aquí-->

</body>
</html>