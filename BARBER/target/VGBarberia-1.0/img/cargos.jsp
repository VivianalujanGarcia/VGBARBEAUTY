<%@ include file="header.jsp" %>
<% 
if (rol != null) {
    if (rol.equals("ADMINISTADOR") || rol.equals("SECRETARIO")) { 
%>
<link rel="stylesheet" href="assets/css/paginacion_general.css"/>
<script src="controlador/cargo.js"></script>
<div class="row">
    <div class="col-md-10 d-flex justify-content-center align-items-center">
        <div class="container mt-10 mb-10">
            <div class="card border-primary shadow-lg">
                <div class="card-body">
                    <form id="form" class="p-5">
                        <h2>Formulario Cargo</h2>
                        <input type="hidden" name="listar" id="listar" value="cargar">
                        <input type="hidden" name="pk" id="pk">
                        <div class="form-group">
                            <label for="nombre">Nombre:</label>
                            <input type="text" class="form-control" name="nombre" id="nombre" placeholder="Ingrese el nombre" required>
                            </select>
                        </div>
                        <input name="boton" id="boton" type="button" value="PROCESAR" class="btn btn-secondary"><br></br>
                    </form>
                    <div id="mensajeAlerta" class="alert" style="display: none;"></div>
                    <div id="mensaje" ></div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-12">
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h4 class="card-title">Cargos
                <button class="btn btn-outline-secondary" data-ciudades="1" title="Imprimir" data-toggle="modal" data-target="#Imprimirl">
    Imprimir Listado General <img src="images/impresora.png" title="Imprimir">
</button>
                </h4>
                <input type="text" id="search" placeholder="Buscar..." class="form-control" style="width: 200px;">
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table" id="resultado" style="min-width: 100px; color: black;">
                        <thead>
                            <tr>
                                <th style="display:none;">ID</th>
                                <th>NOMBRE</th>
                                <th style="text-align: center;">ACCION</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Contenido de la tabla cargado desde el servidor -->
                        </tbody>
                    </table>
                </div>
                <div id="pagination" class="mt-3"></div>
            </div>
        </div>
    </div>
</div>

<!--**********************************
    Modal Eliminar
***********************************-->
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

<!--**********************************
    Modal Imprimir
***********************************-->

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
<% }
} %>
<%@ include file="footer.jsp" %>
