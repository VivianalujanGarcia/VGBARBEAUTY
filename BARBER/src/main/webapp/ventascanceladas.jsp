<%@ include file="header.jsp" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<style>
        body {
            background-color: #FFFFFF; /* Color de fondo */
            font-family: 'Karla', sans-serif; /* Fuente principal */
            margin: 0;
            padding: 0;
        }
 </style>
<script src="ajax/informe_venta_cancelado.js"></script>
<div class="col-md-8 offset-md-2 d-flex justify-content-center align-items-center vh-90">
    <div class="container">
        <div class="card border-primary shadow-lg">
            <div class="card-body">
                <h4 class="text-primary text-center">Informe  de Ventas Canceladas</h4>
                <form action="#" id="form" enctype="multipart/form-data" method="POST" role="form"  class="form-horizontal form-groups-bordered">
                    <div class="form-group">
                        <input class=" form-control" type="hidden" name="idventas" id="idventas" placeholder=" Codigo " readonly>
                        <input class=" form-control" type="hidden" name="iddetalleventas" id="iddetalleventas" placeholder=" Codigo " readonly>
                    </div>
                    <div class="form-group">
                        <label for="fecha_desde" class="form-label">Fecha desde:</label>
                        <input type="date" id="fecha_desde" name="fecha_desde" class="form-control" >
                    </div>
                    <div class="form-group">
                        <label for="fecha_hasta" class="form-label">Fecha hasta:</label>
                        <input type="date" id="fecha_hasta" name="fecha_hasta" class="form-control" >
                    </div>
                    <div class="form-group mt-4 d-flex justify-content-center">
                        <button type="submit" class="btn btn-primary" id="buscar" title="Buscar" data-toggle="modal" data-target="#Imprimirl">Buscar</button>
                    </div>

                </form>
                <div id="mensajeAlerta" class="alert" style="display: none;"></div>
            </div>
        </div>
    </div>
</div>
                    
                    
                    
<!--**********************************
    Modal Registro
***********************************-->

<div id="Imprimirl" class="modal fade" role="dialog">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-secondary text-white">
                <h4 class="modal-title text-white">Registro de Ventas Canceladas</h4>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <form id="imprimir" action="#" method="post">
                <input type="hidden" name="imprimirs" id="imprimirs" value="imprimirs">
                <div class="modal-body">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table" id="resultado" style="min-width: 100px; color: black;">
                                <thead>
                                    <tr>
                                        <th>N°</th>
                                        <th>FECHA</th>
                                        <th>CLIENTE</th>
                                        <th>RUC</th>
                                        <th>TOTAL</th>
                                </thead>
                                <tbody id="resultados">
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <input type="hidden" name="comp" id="comp">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-primary" name="imprimi" id="imprimi" data-dismiss="modal">Imprimir</button>
                </div>
            </form>
        </div>
    </div>
</div>
        


<%@ include file="footer.jsp" %>
