<%@include file="header.jsp" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // Obtener la fecha actual
    Date fechaActual = new Date();

    // Crear un formateador de fecha
    SimpleDateFormat formateadorFecha = new SimpleDateFormat("dd-MM-yyyy");

    // Formatear la fecha
    String fechaFormateada = formateadorFecha.format(fechaActual);

    String usuario = (String) session.getAttribute("usuario");
    String idUsuario = (String) session.getAttribute("dato"); // Asegúrate de que esto esté definido
%>
<style>
    body {
        background-color: #FFFFFF; /* Color de fondo */
        font-family: 'Karla', sans-serif; /* Fuente principal */
        margin: 0;
        padding: 0;
    }
</style>
<script src="ajax/ajusteinventario.js"></script>
<div class="content-wrapper">
    <section class="content">
        <form action="#" id="form" enctype="multipart/form-data" method="POST" role="form" class="form-horizontal form-groups-bordered">
            <input type="hidden" id="listar" name="listar" value="cargar"/>
            <h3><i></i>DATOS DEL AJUSTE</h3><br>

            <div class="row">
                <div class="col-lg-3 ds">
                    <div class="form-group">
                        <label for="field-12" class="control-label">Usuario</label>
                        <input class="form-control" type="text" id="idusuario" name="idusuario" value="<%= idUsuario != null ? idUsuario : "" %>" readonly>
                    </div>

                    <div class="form-group">
                        <label for="tipos">Tipo:</label>
                        <select class="form-control" name="tipo" id="tipo">
                            <option value="">Selecciona un tipo de ajuste</option>
                            <option value="aumento">Aumento</option>
                            <option value="descuento">Descuento</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="motivos">Motivo:</label>
                        <select class="form-control" name="motivo" id="motivo">
                            <option value="">Selecciona el motivo del ajuste</option>
                            <option value="Daño_Pérdida">Daño o Pérdida</option>
                            <option value="Error_De_Conteo">Error de Conteo</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="field-12" class="control-label">Fecha de Venta</label>
                        <input class="form-control" type="text" name="fecharegistro" id="fecharegistro" autocomplete="off" placeholder="Ingrese Fecha" value="<%= fechaFormateada %>" readonly>
                    </div>

                    <hr>
                    <br>
                </div><!-- /col-lg-3 -->

                <div class="col-lg-9">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="panel panel-border panel-warning widget-s-1">
                                <div class="panel-heading">
                                    <h4 class="mb"><i class="fa fa-archive"></i> <strong>Detalle Del Ajuste</strong></h4>
                                </div>
                                <div class="panel-body">
                                    <div id="error">
                                        <!-- error will be shown here ! -->
                                    </div>
                                    <div class="row">
                                        <div class="col-md-5">
                                            <div class="form-group">
                                                <label for="field-5" class="control-label">Búsqueda de Articulo: <span class="symbol required"></span></label>
                                                <input type="hidden" id="codproducto" name="codproducto">
                                                <select class="form-control" name="id_producto" id="id_producto" onchange="dividirproducto(this.value)"></select>
                                            </div>
                                        </div>

                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label for="cantidad_del_producto">Cantidad del producto:</label>
                                                <input type="number" class="form-control" name="cantidad" id="cantidad" placeholder="cantidad del producto" readonly />
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label for="cantidad_ajuste">Cantidad de ajuste:</label>
                                                <input type="number" class="form-control" name="cant_ajuste" id="cant_ajuste" value="1" placeholder="Cantidad" min="0" />
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <input class="form-control" type="hidden" name="cant_actual" id="cant_actual" placeholder="Codigo" readonly>
                                            </div>
                                        </div>
                                    </div>

                                    <div align="right">
                                        <button type="button" name="agregar" value="agregar" id="AgregaProducto" class="btn btn-primary" onclick=""><span class="mdi mdi-cart-plus"></span> Agregar</button>
                                        <div id="respuesta"></div>
                                    </div>
                                    <hr>

                                    <div class="row">
                                        <div class="col-md-12">
                                            <div class="table-responsive">
                                                <table class="table table-striped table-bordered dt-responsive nowrap" id="carrito">
                                                    <thead>
                                                        <tr>
                                                            <th><div align="center">Acción</div></th>
                                                            <th><div align="center">Producto</div></th>
                                                            <th><div align="center">Cantidad Del Producto</div></th>
                                                            <th><div align="center">Cantidad Del Ajuste</div></th>
                                                            <th><div align="center">Cantidad Actual</div></th>
                                                        </tr>
                                                    </thead>
                                                    <tbody id="resultados"></tbody>
                                                </table>
                                                <table width="302" id="carritototal"></table>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="modal-footer">
                                        <button class="btn btn-danger" type="reset" id="btn-cancelar"><span class="mdi mdi-cancel"></span> Cancelar</button>
                                        <button type="button" name="btn" id="btn-finalizar" class="btn btn-primary"><span class="mdi mdi-note-plus-outline"></span> Registrar</button>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div><!-- /row -->
                </div><!-- /col-lg-9 END SECTION MIDDLE -->
            </div>
        </form>
    </section>
</div>

<!-- Modal -->
<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Eliminar Detalle</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                ¿Está seguro de que desea eliminar el registro?
                <input type="hidden" name="idpk" id="idpk" />
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">NO</button>
                <button type="button" class="btn btn-primary" id="eliminar-registro-detalle" data-dismiss="modal">SI</button>
            </div>
        </div>
    </div>
</div>

<%@include file="footer.jsp" %>
