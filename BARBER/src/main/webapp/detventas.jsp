<%@include file="header.jsp" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // Conectar a la base de datos
    Connection con = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    String numeroFactura = "-001"; // Valor por defecto en caso de que no haya facturas

    try {
        // Establecer la conexión con PostgreSQL
        Class.forName("org.postgresql.Driver");
        con = DriverManager.getConnection("jdbc:postgresql://localhost:5432/VGBarberia", "postgres", "1");

        // Consulta para obtener el siguiente número de factura desde la secuencia
        String query = "SELECT MAX(numero) + 1 AS numero FROM ventas";
        stmt = con.prepareStatement(query);
        rs = stmt.executeQuery();

        if (rs.next()) {
            // Obtener el siguiente número de factura desde la secuencia
            numeroFactura = String.format("%01d", rs.getInt(1));  // Formatear a 1 dígitos
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        // Cerrar conexiones
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
    }

    // Obtener la fecha actual
    Date fechaActual = new Date();
    SimpleDateFormat formateadorFecha = new SimpleDateFormat("dd-MM-yyyy");
    String fechaFormateada = formateadorFecha.format(fechaActual);
%>

<style>
    body {
        background-color: #FFFFFF; /* Color de fondo */
        font-family: 'Karla', sans-serif; /* Fuente principal */
        margin: 0;
        padding: 0;
    }
</style>


<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-qrcode/1.0.0/jquery.qrcode.min.js"></script>
<script src="ajax/metodoventa.js"></script>

<div class="content-wrapper">
    <section class="content">
        <form action="#" id="form" enctype="multipart/form-data" method="POST" role="form" class="form-horizontal form-groups-bordered">
            <input type="hidden" id="listar" name="listar" value="cargar"/>
            <h3><i></i>Ventas de Articulos</h3><br>


            <div class="row">
                <div class="col-lg-3 ds">
                    <!--COMPLETED ACTIONS DONUTS CHART-->
                    <h5>DATOS DEL CLIENTE

                    </h5>

                    <div class="form-group">
                        <label for="numero">Número de Factura:</label>
                        <input class="form-control number" value="<%= numeroFactura %>" type="text" name="numero" id="numero" readonly autocomplete="off" placeholder="Número de la factura">
                    </div>
                    <div class=" form-group ">
                        <label for="condicion">Condicion:</label>
                        <select class="form-control" name="condicion" id="condicion">
                            <option value="">Selecciona una condición</option>
                            <option value="contado">Contado</option>
                            <option value="credito">Credito</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="field-12" class="control-label">Cliente</label>

                        <select class="form-control" name="id_cliente" id="id_cliente" onchange="dividiralumno(this.value)">

                        </select>
                    </div>

                    <div class="form-group">
                        <label for="field-12" class="control-label">Documento</label>
                        <input type="hidden" id="codalumno" name="codalumno">
                        <input class="form-control" type="text" value="" name="ci" id="ci" onKeyUp="this.value = this.value.toUpperCase();" autocomplete="off" placeholder="Cedula" readonly="readonly" required><small><span class="symbol required"></span> </small>
                    </div>

                    <div class="form-group">
                        <label for="field-12" class="control-label">Fecha de Venta</label>
                        <input class="form-control" type="text" name="fecharegistro" id="fecharegistro" onKeyUp="" autocomplete="off" placeholder="Ingrese Fecha" value="<%= fechaFormateada%>" readonly>

                    </div>

                    <hr>
                    <br>

                </div><!-- /col-lg-3 -->

                <div class="col-lg-9">

                    <div class="row">
                        <!-- TWITTER PANEL -->

                        <div class="col-lg-12">
                            <div class="panel panel-border panel-warning widget-s-1">
                                <div class="panel-heading">
                                    <h4 class="mb"><i class="fa fa-archive"></i> <strong>Detalle De Venta</strong> </h4>
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
                                                <select class="form-control" name="id_producto" id="id_producto" onchange="dividirproducto(this.value)">

                                                </select>
                                            </div>
                                        </div>


                                        <div class="col-md-3">
                                            <div class="form-group">
                                                <label for="field-3" class="control-label">Precio Venta: <span class="symbol required"></span></label>

                                                <input class="form-control" type="text" name="precio" id="precio" autocomplete="" placeholder="precio" required onkeyup="puntitos(this, this.value.charAt(this.value.length - 1))" readonly="readonly">
                                            </div>
                                        </div>


                                        <div class="col-md-2">
                                            <div class="form-group">
                                                <label for="field-2" class="control-label">Cantidad: <span class="symbol required"></span></label>
                                                <input class="form-control number" value="1" type="text" name="cantidad" id="cantidad" onKeyUp="this.value = this.value.toUpperCase();" autocomplete="off" placeholder="Cantidad">
                                            </div>
                                        </div>

                                    </div>



                                    <div align="right">
                                        <button type="button" name="agregar" value="agregar" id="AgregaProductoVentas" class="btn btn-primary" onclick=""><span class="mdi mdi-cart-plus"></span> Agregar</button>
                                        <div id="respuesta"></div>
                                    </div>
                                    <hr>



                                    <div class="row">
                                        <div class="col-md-12">
                                            <div class="table-responsive">
                                                <table class="table table-striped table-bordered dt-responsive nowrap" id="carrito">
                                                    <thead>
                                                        <tr>
                                                            <th>
                                                                <div align="center">Acción</div>
                                                            </th>
                                                            <th>
                                                                <div align="center">Articulo</div>
                                                            </th>
                                                            <th>
                                                                <div align="center">Precio</div>
                                                            </th>
                                                            <th>
                                                                <div align="center">Cantidad</div>
                                                            </th>
                                                            <th id="columna_0_por_ciento">
                                                                <div align=" center ">Iva</div>
                                                            </th>

                                                            <th id="subtotal">
                                                                <div align=" center ">Subtotal IVA</div>
                                                            </th>
                                                            <th>
                                                                <div align="center">Total</div>
                                                            </th>

                                                        </tr>
                                                    </thead>

                                                    <tbody id="resultados">

                                                    </tbody>

                                                </table>
                                                <table width="302" id="carritototal">

                                                    <!--tr>
    <td><span class="Estilo9"><label>Descuento:</label></span></td>
    <td><div align="right" class="Estilo9"><label id="lbldescuento" name="lbldescuento">0.00</label><input type="hidden" name="txtDescuento" id="txtDescuento" value="0.00"/></div></td>
    </tr-->
                                                    <tr>

                                                        <td>
                                                            <div align="right" class="Estilo9"><label id="lbltotal" name="lbltotal"></label><input type="hidden" name="txtTotal" id="txtTotal" value="0.00" />
                                                                <input type="hidden" name="txtTotalCompra" id="txtTotalCompra" value="" />
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </div>
                                    </div>





                                    <div class="modal-footer">
                                        <button class="btn btn-danger" type="reset" id="btn-cancelar">
                                            <span class="mdi mdi-cancel"></span> Cancelar
                                        </button>
                                        <button type="button" name="btn-submit" id="btn-finalizar" class="btn btn-primary">
                                            <span class="mdi mdi-note-plus-outline"></span> Registrar
                                        </button>
                                    </div>




                                </div>
                            </div>
                        </div>



                    </div><!-- /row -->
                </div><!-- /col-lg-9 END SECTION MIDDLE -->

            </div>
            <!-- **********************************************************************************************************************************************************
          RIGHT SIDEBAR CONTENT
          *********************************************************************************************************************************************************** -->
        </form>
    </section>
</div>

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
                Esta seguro que desea eliminar el registro?
                <input type="hidden" name="idpk" id="idpk" />
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">NO</button>
                <button type="button" class="btn btn-primary" id="eliminar-registro-detalle" data-dismiss="modal">SI</button>
            </div>
        </div>
    </div>
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


                    <button type="submit" class="btn btn-success">Agregar</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        rellenaralumno();
        rellenararticulo();

        // Inicializamos la visibilidad del modal según la condición seleccionada
        verificarCondicion();

        // Cuando cambie la opción de condición, verificamos si mostramos el método de pago
        $("#condicion").change(function () {
            verificarCondicion();
        });
    });

    // Función para rellenar el select de alumnos
    function rellenaralumno() {
        $.ajax({
            data: {listar: 'buscaralumno'},
            url: 'jsp/busqueda.jsp',
            type: 'post',
            success: function (response) {
                console.log(response);  // Verifica que la respuesta sea correcta
                $("#id_cliente").html(response);
            }
        });
    }

    // Función para dividir los datos del alumno
    function dividiralumno(a) {
        if (a && a.indexOf(',') > -1) {  // Verifica que 'a' sea un string con coma
            var datos = a.split(',');
            $("#codalumno").val(datos[0]);
            $("#ci").val(datos[1]);
        } else {
            console.error("El valor de 'a' es inválido:", a);
        }
    }

    // Función para rellenar el select de productos
    function rellenararticulo() {
        $.ajax({
            data: {listar: 'buscaraarticulo'},
            url: 'jsp/busqueda.jsp',
            type: 'post',
            success: function (response) {
                $("#id_producto").html(response);
            }
        });
    }

    // Función para dividir los datos del producto
    function dividirproducto(a) {
        if (a && a.indexOf(',') > -1) {  // Verifica que 'a' sea un string con coma
            var datos = a.split(',');
            $("#codproducto").val(datos[0]);
            $("#precio").val(datos[1]);
        } else {
            console.error("El valor de 'a' es inválido:", a);
        }
    }

    // Función para agregar un producto a la venta
    $("#AgregaProductoVentas").click(function () {
        var datosform = $("#form").serialize();
        $.ajax({
            data: datosform,
            url: 'jsp/insercionventas.jsp',
            type: 'post',
            success: function (response) {
                $("#respuesta").html(response);
                mostrardetalles();
            }
        });
    });

    // Función para mostrar los detalles de la venta
    function mostrardetalles() {
        $.ajax({
            data: {listar: 'listar'},
            url: 'jsp/insercionventas.jsp',
            type: 'post',
            success: function (response) {
                $("#resultados").html(response);
                mostrartotales();
            }
        });
    }

    // Función para mostrar los totales
    function mostrartotales() {
        $.ajax({
            data: {listar: 'mostrartotales'},
            url: 'jsp/insercionventas.jsp',
            type: 'post',
            success: function (response) {
                $("#lbltotal").html(response);
                $("#txtTotalCompra").val(response);
            }
        });
    }

    // Función para eliminar un registro de detalle
    $("#eliminar-registro-detalle").click(function () {
        var pk = $("#idpk").val();
        $.ajax({
            data: {listar: 'eliminardetalle', pk: pk},
            url: 'jsp/insercionventas.jsp',
            type: 'post',
            success: function (response) {
                mostrardetalles();
            }
        });
    });

    // Función para cancelar la venta
    $("#btn-cancelar").click(function () {
        $.ajax({
            data: {listar: 'cancelarventa'},
            url: 'jsp/insercionventas.jsp',
            type: 'post',
            success: function (response) {
                location.href = 'listarventas.jsp';
            }
        });
    });

    
// Función para manejar el botón "Finalizar"
$("#btn-finalizar").click(function () {
    var condicion = $("#condicion").val(); // Verificar la condición seleccionada
    var total = $("#txtTotalCompra").val(); // Obtener el total de la compra

    if (condicion === "contado") {
        // Mostrar el modal para agregar método de pago
        $('#agregarMetodoModal').modal('show');

        // Manejar el envío del formulario dentro del modal
        $("#formAgregarMetodo").submit(function (e) {
            e.preventDefault(); // Prevenir envío por defecto

            var metodoPago = $("#metodoModal").val();
            var banco = $("#bancoModal").val();

            // Validar que se hayan seleccionado ambos valores
            if (!metodoPago || !banco) {
                alert("Por favor, selecciona un método de pago y un banco.");
                return;
            }

            // Enviar los datos vía AJAX
            $.ajax({
                data: { listar: 'finalizarventa', total: total, metodoPago: metodoPago, banco: banco },
                url: 'jsp/insercionventas.jsp',
                type: 'post',
                success: function (response) {
                    // Redirigir a la página de ventas después del éxito
                    location.href = 'listarventas.jsp';
                }
            });

            // Cerrar el modal
            $('#agregarMetodoModal').modal('hide');
        });
    } else if (condicion === "credito") {
        // Si la condición es "credito", procesar directamente la venta
        $.ajax({
            data: { listar: 'finalizarventa', total: total, metodoPago: "credito", banco: null },
            url: 'jsp/insercionventas.jsp',
            type: 'post',
            success: function (response) {
                // Redirigir a la página de ventas después del éxito
                location.href = 'listarventas.jsp';
            }
        });
    }
});

    // Mostrar u ocultar la sección del código QR según el método de pago seleccionado
    $("#metodoModal").change(function () {
        var metodoPago = $(this).val();
        

        if (metodoPago === "QR") {
            $("#qrSection").show();
            generarCodigoQR($("#qrtotal").val()); // Pasa el monto o lo que sea necesario para el QR
        } else {
            $("#qrSection").hide();
            $("#qrCode").empty(); // Limpiar el QR si se selecciona otro método
        }
    });

    // Función para generar el código QR
    function generarCodigoQR(monto) {
        if (typeof QRCode !== 'undefined') {
            new QRCode(document.getElementById("qrCode"), {
                text: monto, // Pasa aquí lo que desees incluir en el QR (en este caso, el monto con IVA)
                width: 128,
                height: 128,
                colorDark: "#000000",  // Color del código QR (negro)
                colorLight: "#ffffff", // Color de fondo (blanco)
                correctLevel: QRCode.CorrectLevel.H // Nivel de corrección de errores
            });
        } else {
            console.error("La librería QRCode no está definida.");
        }
    }

    // Asegúrate de que la librería QRCode esté cargada correctamente
    $(document).ready(function () {
        var script = document.createElement('script');
        script.src = "https://cdn.rawgit.com/davidshimjs/qrcodejs/gh-pages/qrcode.min.js";
        document.head.appendChild(script);
    });

    function verificarCondicion() {
    var condicion = $("#condicion").val();

    if (condicion === "contado") {
        // Mostrar los campos del modal
        $("#metodoModal").prop("disabled", false);
        $("#metodoModal").closest('.form-group').show();
        $("#bancoModal").prop("disabled", false);
        $("#bancoModal").closest('.form-group').show();
    } else if (condicion === "credito") {
        // Ocultar los campos y forzar el cierre del modal si está abierto
        $("#metodoModal").prop("disabled", true);
        $("#metodoModal").closest('.form-group').hide();
        $("#bancoModal").prop("disabled", true);
        $("#bancoModal").closest('.form-group').hide();
        
        if ($('#agregarMetodoModal').is(':visible')) {
            $('#agregarMetodoModal').modal('hide');
        }
    }
}


</script>

<%@include file="footer.jsp" %>