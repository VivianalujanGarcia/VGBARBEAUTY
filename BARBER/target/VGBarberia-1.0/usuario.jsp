<%@include file="header.jsp" %>
<script src="ajax/usuarios.js"></script>
<style>
    body {
        background-color: #FFFFFF; /* Color de fondo */
        font-family: 'Karla', sans-serif; /* Fuente principal */
        margin: 0;
        padding: 0;
    }
    
    .container {
        display: flex; /* Usamos flexbox para alinear */
        gap: 20px; /* Espacio entre el formulario y el listado */
    }

    .col-3, .col-md-3 {
        flex: 1; /* Ambos elementos tendrán el mismo tamaño flexible */
    }

    .card, .table {
        height: 100%; /* Ambos tendrán la misma altura */
    }

    .table {
        margin-top: 0;
    }

    .card-body {
        height: 100%;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
    }
</style>

<div class="container">
    <!-- Formulario Usuario -->
    <div class="col-3">
        <div class="card">
            <div class="card-body">
                <form id="form">
                    <h5 class="card-title mb-0">Formulario Usuario</h5>
                    <input type="hidden" name="listar" id="listar" value="cargar">
                    <input type="hidden" name="pk" id="pk">
                    <div class="mb-3">
                        <label for="nombre" class="form-label">Datos:</label>
                        <input type="text" id="datos" name="datos" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label for="correo" class="form-label">Usuario:</label>
                        <input type="text" id="usuario" name="usuario" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label for="clave" class="form-label">Contraseña:</label>
                        <input type="password" id="clave" name="clave" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label for="tipo" class="form-label">Rol:</label>
                        <select id="rol" class="form-control" name="rol" required>
                            <option value="ADMINISTRADOR">Administrador</option>
                            <option value="USUARIO">Usuario</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="tipo" class="form-label">Estado:</label>
                        <select id="estado" class="form-control" name="estado" required>
                            <option value="A">A</option>
                            <option value="I">I</option>
                        </select>
                    </div>
                    <input type="button" id="boton" name="boton" class="btn btn-success" value="Guardar">
                    <div id="mensaje" class="mt-3"></div>
                    <div id="mensajealer" class="alert" style="display: none;"></div>
                </form>
            </div>
        </div>
    </div>

    <!-- Listado de Usuarios -->
    <div class="col-md-8">
        <h1>Listado de Usuarios <button class="btn btn-outline-secondary" data-ciudades="1" title="Imprimir" data-toggle="modal" data-target="#Imprimirl">
    Imprimir Listado General <img src="img/impresora (1).png" title="Imprimir">
</button></h1>
        <table class="table" id="resultado">
            <thead>
                <tr>
                    <th scope="col">Id</th>
                    <th scope="col">Datos</th>
                    <th scope="col">Usuario</th>
                    <th scope="col">Contraseña</th>
                    <th scope="col">Rol</th>
                    <th scope="col">Estado</th>
                    <th scope="col">Acción</th>
                </tr>
            </thead>
            <tbody>
                <!-- Aquí se cargan los datos -->
            </tbody>
        </table>
    </div>
</div>

<!-- Modal Eliminar -->
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

<!-- Modal Imprimir -->
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
                    <p class="text-secondary">¿Estás seguro de que deseas Imprimir este registro?</p>
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
<%@include file="footer.jsp"%>
