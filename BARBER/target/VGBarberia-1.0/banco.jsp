<%@ include file="header.jsp" %>
<script src="ajax/banco.js"></script>
<style>
        body {
            background-color: #FFFFFF; /* Color de fondo */
            font-family: 'Karla', sans-serif; /* Fuente principal */
            margin: 0;
            padding: 0;
        }
 </style>
<div class="row">
    <!-- Formulario de Método de Pago -->
    <div class="col-md-6">
        <div class="card">
            <div class="card-body">
                <form id="form">
                    <h5 class="card-title mb-0">Formulario Banco</h5>
                    <input type="hidden" name="listar" id="listar" value="cargar">
                    <input type="hidden" name="pk" id="pk">
                    <div class="mb-3">
                        <label for="metodo" class="form-label">Banco:</label>
                        <input type="text" id="nombre" name="nombre" class="form-control" required>
                    </div>
                    
              

                    <button type="button" id="boton" name="boton" class="btn btn-success">Cargar</button>
                    <div id="mensajealer" class="alert" style="display: none;"></div>
                    <div id="mensaje" class="mt-3"></div>
                </form>
            </div>
        </div>
    </div>

    <!-- Listado de Métodos de Pago -->
    <div class="col-md-6">
        <div class="card">
            <div class="card-body">
                <h1>Listado de Bancos <button class="btn btn-outline-secondary" data-ciudades="1" title="Imprimir" data-toggle="modal" data-target="#Imprimirl">
    Imprimir Listado General <img src="img/impresora (1).png" title="Imprimir">
</button></h1>
                <table class="table" id="resultado">
                    <thead>
                        <tr>
                            <th scope="col">Id</th>
                            <th scope="col">Nombre</th>
                           
                            <th scope="col">Acción</th>
                        </tr>
                    </thead>
                    <tbody>

                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Modal -->
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

<!--**********************************
    Modal Imprimir Reporte General 
***********************************-->

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
                    <input type="hidden" name="ciudades" id="ciudades">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-dismiss="modal">Cancelar</button>
                    <button type="button" class="btn btn-primary" name="imprimi" id="imprimi">Imprimir</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
