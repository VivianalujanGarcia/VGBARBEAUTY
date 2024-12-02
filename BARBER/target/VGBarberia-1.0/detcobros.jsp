<%@ include file="header.jsp" %>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    int idcaja = 0; // Inicializa la variable
    Connection conn = null;
    Statement st = null;
    ResultSet rs = null;
    PreparedStatement stmt = null;

    // Obtener la fecha actual
    Date fechaActual = new Date();
    SimpleDateFormat formateadorFecha = new SimpleDateFormat("dd-MM-yyyy");
    String fechaFormateada = formateadorFecha.format(fechaActual);
    
    String numeroFactura = "-001"; // Valor por defecto en caso de que no haya facturas

    try {
        // Establecer la conexión con PostgreSQL
        Class.forName("org.postgresql.Driver");
        conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/VGBarberia", "postgres", "1");

        // Consulta para obtener el id de la caja abierta
        st = conn.createStatement();
        rs = st.executeQuery("SELECT id FROM abrircaja WHERE estado = 'ABIERTO'");
        if (rs.next()) {
            idcaja = rs.getInt("id"); // Asumiendo que hay una columna 'id'
        }

        // Consulta para obtener el siguiente número de factura desde la secuencia
        String query = "SELECT MAX(numero) + 1 AS numero FROM cobros";
        stmt = conn.prepareStatement(query);
        rs = stmt.executeQuery();

        if (rs.next()) {
            // Obtener el siguiente número de factura
            int nextFactura = rs.getInt(1);
            numeroFactura = String.format("%03d", nextFactura);  // Formatear a 3 dígitos
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (st != null) st.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<style>
    body {
        background-color: #FFFFFF; /* Color de fondo */
        font-family: 'Karla', sans-serif; /* Fuente principal */
        margin: 0;
        padding: 0;
    }
</style>
<script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>

<script src="ajax/metodo.js"></script>
<div class="content-wrapper">
    <section class="content">
        <form action="#" id="form" enctype="multipart/form-data" method="POST" role="form" class="form-horizontal form-groups-bordered">
            <input type="hidden" id="listar" name="listar" value="cargar"/>
            <div class="row">
                <div class="col-lg-3 ds">
                    <h5>DATOS DEL COBRO</h5>
                    <div class="form-group">
                        <input class="form-control" type="hidden" name="idabrircaja" id="idabrircaja" value="<%= idcaja %>" placeholder="Codigo" readonly> 
                    </div>
                    <div class="form-group">
                        <label for="numero">Número de Factura:</label>
                        <input class="form-control number" value="<%= numeroFactura %>" type="text" name="numero" id="numero" readonly autocomplete="off" placeholder="Número de la factura">
                    </div>
                    <div class="form-group">
                        <label for="field-12" class="control-label">Fecha:</label>
                        <input class="form-control" type="text" name="fecharegistro" id="fecharegistro" autocomplete="off" placeholder="Ingrese Fecha" value="<%= fechaFormateada %>" readonly>
                    </div>
                    <div class="form-group">
                        <label for="field-12" class="control-label">Cliente</label>
                        <select class="form-control" name="id_cliente" id="id_cliente" onchange="dividiralumno(this.value)">
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="field-12" class="control-label">Ci:</label>
                        <input type="hidden" id="codalumno" name="codalumno">
                        <input class="form-control" type="text" value="" name="ci" id="ci" onKeyUp="this.value = this.value.toUpperCase();" autocomplete="off" placeholder="Cedula" readonly="readonly" required>
                        <small><span class="symbol required"></span></small>
                    </div>
                    <hr>
                    <br>
                </div><!-- /col-lg-3 -->

                <div class="col-lg-9">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="panel panel-border panel-warning widget-s-1">
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table" id="carrito" style="min-width: 100px; color: black;">
                                            <thead>
                                                <tr>
                                                    <th><div align="center">N° Cuenta</div></th>
                                                    <th><div align="center">Vencimiento</div></th>
                                                    <th><div align="center">Monto</div></th>
                                                    <th><div align="center">N° Cuota</div></th>
                                                    <th><div align="center">Cobrar</div></th>
                                                </tr>
                                            </thead>
                                            <tbody id="resultados"></tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
<!-- Contenedor para los mensajes -->
<div id="mensaje" class="alert" style="display: none;"></div>

                            <div class="modal-footer">
                                <button class="btn btn-outline-danger" type="reset" onclick="#" id="btn-cancelar"><span class="mdi mdi-cancel"></span> Cancelar</button>
                                <button type="button" name="btn-submit" id="btn-finalizar" class="btn btn-outline-primary"><span class="mdi mdi-note-plus-outline"></span> Registrar</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div><!-- /row -->
        </form>
    </section>
</div>

<!-- Modal Agregar Método de Pago -->
<div id="agregarMetodoModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="agregarMetodoModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-secondary text-white">
                <h5 class="modal-title" id="agregarMetodoModalLabel">Agregar Método de Pago</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Cerrar">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="formAgregarMetodo">
                    <div class="form-group">
                        <label for="metodo">Método:</label>
                        <!--<input type="text" class="form-control" name="metodo" id="metodoModal" required>-->
                         <select class="form-control" name="metodo" id="metodoModal">
                            <option value="">Selecciona un metodo de pago</option>
                            <option value="Tarjeta de Crédito">Tarjeta de Crédito</option>
                            <option value="Transferencia Bancaria">Transferencia Bancaria</option>
                            <option value="Efectivo">Efectivo</option>
                            <option value="QR">QR</option>
                            <option value="Cheque">Cheque</option>
                            
                        </select>
                    </div>
                    
                    <div class="form-group" id="qrSection" style="display: none;">
                        <label for="qrCode">Código QR:</label>
                        <div id="qrCode" style="text-align: center;"></div>
                    </div>
                    
                    
                    <div class="form-group">
                        <label for="banco">Banco:</label>
                        <!--<input type="text" class="form-control" name="banco" id="bancoModal" required>-->
                         <select class="form-control" name="banco" id="bancoModal">
                            <option value="">Selecciona un Banco</option>
                            <option value="Itau">Itau</option>
                            <option value="Ueno">Ueno</option>
                             <option value="-">-</option>
                            <option value="Continental">Continental</option>
                            <option value="Familiar">Familiar</option>
                            <option value="Regional">Regional</option>
                            <option value="Atlas">Atlas</option>
                        </select>
                    </div>
                    <!-- Asegúrate de que el campo montoTotal esté presente en tu HTML -->
                    <!--<input type="checkbox" class="cuentas" data-monto="1500" value="1">
                    <input type="checkbox" class="cuentas" data-monto="2500" value="2">-->

                   <div align="right" class="Estilo9">
    <label id="lbltotal" name="lbltotal"></label>
    <input type="hidden" name="txtTotal" id="txtTotal" value="0.00" />
    <input type="hidden" name="txtTotalCompra" id="txtTotalCompra" value="" />
</div>

<div id="mensaje" style="display:none; color: red;"></div>

                    <button type="submit" class="btn btn-success">Agregar</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        rellenaralumno();
    });

    function rellenaralumno() {
        $.ajax({
            data: {listar: 'buscaralumno'},
            url: 'jsp/buscadordetallecobro.jsp',
            type: 'post',
            success: function (response) {
                $("#id_cliente").html(response);
            }
        });
    }

    function dividiralumno(a) {
        if (a) {
            var datos = a.split(',');
            $("#codalumno").val(datos[0]);
            $("#ci").val(datos[1]);
            cargarCuentaPendiente(datos[0]);
        } else {
            console.error("No hay datos para dividir.");
        }
    }

    function cargarCuentaPendiente(clienteId) {
        $.ajax({
            data: {listar: 'cargarcuentapendiente', clienteId: clienteId},
            url: 'jsp/buscadordetallecobro.jsp',
            type: 'post',
            success: function (response) {
                $("#resultados").html(response);
            },
            error: function (xhr, status, error) {
                console.error("Error al cargar cuentas pendientes: " + error);
            }
        });
    }

    $("#btn-cancelar").click(function () {
        $.ajax({
            data: {listar: 'cancelar'},
            url: 'jsp/buscadordetallecobro.jsp',
            type: 'post',
            success: function (response) {
                location.href = 'cobros.jsp';
            }
        });
    });

$("#btn-finalizar").click(function () {
    let cb = document.getElementsByClassName("cuentas");
    let cuentas = [];
    let montoTotal = 0; // Variable para almacenar el monto total

    // Recorrer los checkboxes para obtener las cuentas seleccionadas
    for (let i = 0; i < cb.length; i++) {
        if (cb[i].checked === true) {
            cuentas.push(cb[i].value); // Almacenar las cuentas seleccionadas
            let monto = parseFloat(cb[i].getAttribute("data-monto")); // Obtener el monto de cada cuenta
            if (!isNaN(monto)) {
                montoTotal += monto; // Sumar el monto total
            }
        }
    }

    if (cuentas.length > 0) {
        // Mostrar el modal para elegir el método de pago
        $("#agregarMetodoModal").modal("show");

        // Establecer el valor del montoTotal en el campo oculto
        $("#montoTotal").val(montoTotal.toFixed(2)); // Guardar el monto total con 2 decimales

        // Generar el código QR con el monto total
        var montoQr = "Monto: " + montoTotal.toFixed(2) + " GS"; // Formato de monto con la moneda
        new QRCode(document.getElementById("qrCode"), montoQr); // Generar el código QR

        // Al confirmar el método de pago en el modal
        $("#formAgregarMetodo").off("submit").on("submit", function (e) {
            e.preventDefault();

            // Obtener valores del método de pago
            let metodo = $("#metodoModal").val();
            let banco = $("#bancoModal").val();

            if (metodo && banco) {
                // Enviar la solicitud AJAX después de confirmar el método de pago
                $.ajax({
                    data: {
                        listar: 'finalizar',
                        id_cliente: $("#codalumno").val(),
                        idabrircaja: $("#idabrircaja").val(),
                        fecharegistro: $("#fecharegistro").val(),
                        numero: $("#numero").val(),
                        idcuentaclientes: cuentas,
                        metodo_pago: metodo,
                        banco: banco,
                        monto_total: montoTotal.toFixed(2) // Enviar el monto total con 2 decimales
                    },
                    url: 'jsp/buscadordetallecobro.jsp',
                    type: 'post',
                    success: function (response) {
                        location.href = 'cobros.jsp';
                    }
                });

                // Ocultar el modal después de enviar
                $("#agregarMetodoModal").modal("hide");
            } else {
                alert("Por favor, complete todos los campos del método de pago.");
            }
        });
    } else {
        alert("Seleccione al menos una cuenta para finalizar.");
    }
});


</script>
<%@ include file="footer.jsp" %>
