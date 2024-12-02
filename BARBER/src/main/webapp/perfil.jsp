<%@include file="header.jsp"%>

<style>
        body {
            background-color: #FFFFFF; /* Color de fondo */
            font-family: 'Karla', sans-serif; /* Fuente principal */
            margin: 0;
            padding: 0;
        }
 </style>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Presentación de perfil</title>
    <style>
        /* Estilos CSS para la tarjeta */
        .card {
            border: 1px solid #ccc;
            padding: 20px;
            max-width: 300px;
            margin: 0 auto;
        }
    </style>
</head>
<body>
  
      <section class="vh-100">
  <div class="container py-5 h-100">
    <div class="row d-flex justify-content-center align-items-center h-100">
      <div class="col-md-12 col-xl-4">

        <div class="card" style="border-radius: 15px;">
          <div class="card-body text-center">
            <div class="mt-3 mb-4">
          <img src="assets/images/background/miperfil.jpg" 
                class="rounded-circle img-fluid" style="width: 100px;" />
            </div>
            <h4 class="mb-2">Viviana Garcia</h4>
            <p class="text-muted mb-4">@Programmer & Desinger</p>
            <div class="mb-4 pb-2">
              <button  type="button" data-mdb-button-init data-mdb-ripple-init class="btn btn-outline-primary btn-floating">
               <a href="https://www.facebook.com/luji.vivi18/"> <i class="fab fa-facebook-f fa-lg"></i></a> 
              </button>
              <button  type="button" data-mdb-button-init data-mdb-ripple-init class="btn btn-outline-primary btn-floating">
                <a href="https://www.instagram.com/viviana.garcia1803/"><i class="fab fa-instagram fa-lg"></i></a> 
              </button>
              <button  type="button" data-mdb-button-init data-mdb-ripple-init class="btn btn-outline-primary btn-floating">
              <a href="https://x.com/luji_viviana18"> <i class="fab fa-twitter fa-lg"></i></a> 
              </button>
            </div>
            <a href="https://wa.link/phep8n"  type="button" data-mdb-button-init data-mdb-ripple-init class="btn btn-primary btn-rounded btn-lg">
              Message now
            </a>
     
          </div>
        </div>

      </div>
    </div>
  </div>
</section>                  
    </body>
</html>
         
    
<%@include file="footer.jsp"%>
