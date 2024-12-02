<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <title>VGBARBERIA</title>

    <!-- GOOGLE FONTS -->
    <link href="https://fonts.googleapis.com/css?family=Karla:400,700|Roboto" rel="stylesheet">
    <link href="source/plugins/material/css/materialdesignicons.min.css" rel="stylesheet" />
    <link href="source/plugins/simplebar/simplebar.css" rel="stylesheet" />

    <!-- PLUGINS CSS STYLE -->
    <link href="source/plugins/nprogress/nprogress.css" rel="stylesheet" />

    <!-- MONO CSS -->
    <link id="main-css-href" rel="stylesheet" href="theme/css/style.css" />

    <!-- FAVICON -->
    <link href="source/images/VBARBERIA-removebg-preview.png" rel="shortcut icon" />

    <!--
      HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries
    -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
    <script src="source/plugins/nprogress/nprogress.js"></script>
    <style>
        body {
            background-color: #370067; /* Color de fondo */
            font-family: 'Karla', sans-serif; /* Fuente principal */
            margin: 0;
            padding: 0;
        }
        .container {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
        }
        .card {
            border: none; /* Quita el borde del card */
            border-radius: 10px; /* Bordes redondeados */
            box-shadow: 0 0 20px rgba(0,0,0,0.1); /* Sombra suave */
            text-align: center; /* Alineación centrada */
            padding: 30px; /* Espaciado interno */
            max-width: 400px; /* Ancho máximo de la tarjeta */
            width: 100%; /* Ancho completo en dispositivos pequeños */
        }
        .app-brand {
            margin-bottom: 20px; /* Espacio bajo el logo y el texto */
        }
        .brand-name {
            display: block;
            font-size: 24px;
            margin-top: 10px; /* Espacio sobre el texto */
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="card">
            <div class="app-brand">
                <span class="brand-name text-dark">¡Bienvenido a VGBarberia!</span>
                <img src="img/VBARBERIA-removebg-preview.png" alt="Mono" style="max-width: 150px;">
            </div>

            <h4 class="text-dark mb-4">Inicia sesión</h4>

            <form action="/index.jsp" method="POST" id="form">
                <div class="form-group mb-4">
                    <input type="text" class="form-control" id="usuario" name="usuario" placeholder="USUARIO">
                </div>
                <div class="form-group mb-4">
                    <input type="password" class="form-control" id="passw" name="passw" placeholder="CONTRASEÑA">
                </div>

                <button type="button" id="btn-acceder" class="btn btn-primary btn-block">Ingresar</button>
                  
            </form>
            <div id="mensaje"> </div>
        </div>
    </div>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
 $(document).ready(function() {
    $("#btn-acceder").click(function() {
        datosform = $("#form").serialize();
        $.ajax({
            data: datosform,
            url: 'jsp/login.jsp',
            type: 'post',
            beforeSend: function () {
                // Puedes mostrar un mensaje de carga si deseas
                // $("#resultado").html("Procesando, espere por favor...");
            },
            success: function (response) {
                
                $("#mensaje").html(response);
                
                // Limpiar los campos del formulario
                $("#form")[0].reset(); // Esto limpia todos los campos del formulario
            }
        });
    });
});

    </script>
</body>
</html>
