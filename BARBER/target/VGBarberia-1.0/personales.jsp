<%@include file="header.jsp" %>
<script src="ajax/personales.js"></script>
<style>
    body {
        background-color: #FFFFFF; /* Color de fondo */
        font-family: 'Karla', sans-serif; /* Fuente principal */
        margin: 0;
        padding: 0;
    }

    .container {
        margin-top: 20px;
    }

    .card {
        margin-bottom: 20px;
    }

    h1 {
        font-size: 24px;
        margin-bottom: 20px;
    }

    .form-label {
        font-weight: bold;
    }

    .table th,
    .table td {
        vertical-align: middle;
    }

    .form-container {
        max-width: 100%; /* Ancho máximo */
        padding: 20px;   /* Padding más pequeño */
    }

    .form-container input,
    .form-container select {
        padding: 6px; /* Ajuste de padding para reducir tamaño de los inputs */
        font-size: 14px; /* Tamaño de fuente ajustado */
    }

    .form-container .btn {
        padding: 6px 12px; /* Ajuste del tamaño del botón */
        font-size: 14px;   /* Ajuste del tamaño de texto del botón */
    }

    .table-container {
        padding-left: 15px; /* Ajustar separación con el formulario */
    }
</style>

<div class="container">
    <div class="row">
        <!-- Formulario de Personales más compacto -->
        <div class="md-3">
            <div class="card form-container">
                <div class="card-body">
                    <form id="form">
                        <h5 class="card-title mb-0">Formulario Personales</h5>
                        <input type="hidden" name="listar" id="listar" value="cargar">
                        <input type="hidden" name="pk" id="pk">
                        
                        <div class="mb-2">
                            <label for="nombre" class="form-label">Nombre:</label>
                            <input type="text" id="nombre" name="nombre" class="form-control" required>
                        </div>
                        
                        <div class="mb-2">
                            <label for="apellido" class="form-label">Apellido:</label>
                            <input type="text" id="apellido" name="apellido" class="form-control" required>
                        </div>
                        
                        <div class="mb-2">
                            <label for="ci" class="form-label">Ci:</label>
                            <input type="text" id="ci" name="ci" class="form-control" required>
                        </div>
                        
                        <div class="mb-2">
                            <label for="fecha" class="form-label">Fecha Nacimiento:</label>
                            <input type="date" id="fecha" name="fecha" class="form-control" required>
                        </div>
                        
                        <div class="mb-2">
                            <label for="direccion" class="form-label">Dirección:</label>
                            <input type="text" id="direccion" name="direccion" class="form-control" required>
                        </div>
                        
                        <div class="mb-2">
                            <label for="telefono" class="form-label">Teléfono:</label>
                            <input type="text" id="telefono" name="telefono" class="form-control" required>
                        </div>
                        
                       
                        
                        <div class="mb-2">
                            <label for="id_ciudad" class="form-label">Ciudad:</label>
                            <select id="id_ciudad" name="id_ciudad" class="form-control" required>
                                <!-- Aquí se deberían cargar las opciones de ciudad desde la base de datos -->
                            </select>
                        </div>

                        <input type="button" id="boton" name="boton" class="btn btn-success" value="Guardar">
                        <div id="mensaje" class="mt-3"></div>
                        <div id="mensajealer" class="alert" style="display: none;"></div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Listado de Personales -->
        <div class="col-md-8 table-container">
            <h1>Listado de Personales <button class="btn btn-outline-secondary" data-ciudades="1" title="Imprimir" data-toggle="modal" data-target="#Imprimirl">
    Imprimir Listado General <img src="img/impresora (1).png" title="Imprimir"></h1>
            <table class="table table-striped" id="resultado">
                <thead>
                    <tr>
                        <th scope="col">Id</th>
                        <th scope="col">Nombre</th>
                        <th scope="col">Apellido</th>
                        <th scope="col">Ci</th>
                        <th scope="col">Fecha Nac</th>
                        <th scope="col">Dirección</th>
                        <th scope="col">Teléfono</th>
                
                        <th scope="col">Ciudad</th>
                        <th scope="col">Acción</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Aquí se cargarán los registros desde la base de datos -->
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal para Eliminar Registro -->
<div id="Eliminar" class="modal fade" role="dialog">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-secondary text-white">
                <h4 class="modal-title text-white">Eliminar Registro</h4>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <form id="eliminar" action="#" method="post">
                <input type="hidden" name="eliminars" id="eliminars" value="eliminars">
                <div class="modal-body">
                    <p class="text-secondary">¿Estás seguro de que deseas eliminar este registro?</p>
                    <input type="hidden" name="pkdel" id="pkdel">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-primary" name="eliminartodo" id="eliminartodo" data-dismiss="modal">Eliminar</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal para Imprimir Registro -->
<div id="Imprimir" class="modal fade" role="dialog">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-secondary text-white">
                <h4 class="modal-title text-white">Imprimir Registro</h4>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <form id="imprimir" action="#" method="post">
                <input type="hidden" name="imprimirs" id="imprimirs" value="imprimirs">
                <div class="modal-body">
                    <p class="text-secondary">¿Estás seguro de que deseas imprimir este registro?</p>
                    <input type="hidden" name="pkim" id="pkim">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-primary" name="imprimirtodo" id="imprimirtodo" data-dismiss="modal">Imprimir</button>
                </div>
            </form>
        </div>
    </div>
</div>
  <!--************
    Modal Imprimir Reporte General 
*************-->

<div id="Imprimirl" class="modal fade" role="dialog">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-secondary text-white">
                <h4 class="modal-title text-white">Imprimir Registro</h4>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <form id="imprimir" action="#" method="post">
                <input type="hidden" name="imprimirs" id="imprimirs" value="imprimirs">
                <div class="modal-body">
                    <p class="text-secondary">¿Estás seguro de que deseas Imprimir este registro?</p>
                    <input type="hidden" name="im" id="im">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-dismiss="modal">Cancelar</button>
                    <button type="button" class="btn btn-primary" name="imprimi" id="imprimi">Imprimir</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@include file="footer.jsp" %>
