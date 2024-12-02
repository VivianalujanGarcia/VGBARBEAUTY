<%@include file="header.jsp" %>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    int idcaja = 0; // Inicializa la variable
    Connection conn = null;
    Statement st = null;
    ResultSet rs = null;

    try {
        Class.forName("org.postgresql.Driver");
        conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/VGBarberia", "postgres", "1");
        st = conn.createStatement();
        rs = st.executeQuery("SELECT id FROM abrircaja WHERE estado = 'ABIERTO'");
        if (rs.next()) {
            idcaja = rs.getInt("id"); // Asumiendo que hay una columna 'id'
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (st != null) st.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
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

<div class="content-wrapper">
    <section class="content">
        <form action="#" id="form" enctype="multipart/form-data" method="POST" role="form" class="form-horizontal form-groups-bordered">
            <input type="hidden" id="listar" name="listar" value="cargar"/>
       


            <div class="row">
                <div class="col-lg-3 ds">
                    <!--COMPLETED ACTIONS DONUTS CHART-->
                    <h5>DATOS DEL PAGO

                    </h5>
                                <div class="form-group">
                        <input class=" form-control" type="hidden" name="idabrircaja" id="idabrircaja" value="<% out.print(idcaja); %>" placeholder=" Codigo " readonly>
                    </div>
                    <div class="form-group">
                        <label for="numero">Numero:</label>
                        <input class=" form-control" type="number" name="numero" id="numero" onKeyUp="" autocomplete="off" value="1" placeholder="Ingrese el número del cobro " >
                    </div>
                    <div class="form-group">
                        <label for="field-12" class="control-label">Fecha:</label>
                        <input class="form-control" type="text" name="fecharegistro" id="fecharegistro" onKeyUp="" autocomplete="off" placeholder="Ingrese Fecha" value="<%= fechaFormateada %>" readonly>
                    </div>

                    <div class="form-group">
                        <label for="field-12" class="control-label">Proveedor</label>

                        <select class="form-control" name="id_proveedor" id="id_proveedor" onchange="dividiralumno(this.value)">

                        </select>
                    </div>

                    <div class="form-group">
                        <label for="field-12" class="control-label">Ruc:</label>
                        <input type="hidden" id="codalumno" name="codalumno">
                        <input class="form-control" type="text" value="" name="ruc" id="ruc" onKeyUp="this.value = this.value.toUpperCase();" autocomplete="off" placeholder="Cedula" readonly="readonly" required><small><span class="symbol required"></span> </small>
                    </div>

                  

                    <hr>
                    <br>

                </div><!-- /col-lg-3 -->

                     <div class=" col-lg-9 ">
                    <div class=" row ">
                        <div class=" col-lg-12 ">
                            <div class=" panel panel-border panel-warning widget-s-1 ">
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table" id="carrito" style="min-width: 100px; color: black;">
                                            <thead>
                                                <tr>
                                                    <th>
                                                        <div align=" center ">N° Cuenta</div>
                                                    </th>
                                                    <th>
                                                        <div align=" center ">Vencimiento</div>
                                                    </th>
                                                    <th>
                                                        <div align=" center ">Monto</div>
                                                    </th>
                                                    <th>
                                                        <div align=" center ">N° Cuota</div>
                                                    </th>
                                                    <th>
                                                        <div align=" center ">Pagar</div>
                                                    </th>
                                                </tr>
                                            </thead>
                                            <tbody id="resultados">

                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
<div id="mensaje" style="display:none; padding: 10px; border: 1px solid #c82333; background-color: #f80000; color: white; border-radius: 5px; margin-top: 10px;">
</div>




                            <div class=" modal-footer">
                                <button class="btn btn-outline-danger" type="reset" onclick="#" id="btn-cancelar"><span class="mdi mdi-cancel"></span> Cancelar</button>
                                <button type="button" name="btn-submit" id="btn-finalizar" class="btn btn-outline-primary"><span class="mdi mdi-note-plus-outline"></span> Registrar</button>
                            </div>
                        </div>
                    </div>
                </div>


                    </div><!-- /row -->
                </div><!-- /col-lg-9 END SECTION MIDDLE -->

      
            <!-- **********************************************************************************************************************************************************
          RIGHT SIDEBAR CONTENT
          *********************************************************************************************************************************************************** -->
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
                        <select class="form-control" name="metodo" id="metodoModal">
                            <option value="">Selecciona un método de pago</option>
                            <option value="Tarjeta de Crédito">Tarjeta de Crédito</option>
                            <option value="Transferencia Bancaria">Transferencia Bancaria</option>
                            <option value="Efectivo">Efectivo</option>
                           
                            <option value="Cheque">Cheque</option>
                        </select>
                    </div>
                    
                   
                    
                    <div class="form-group">
                        <label for="banco">Banco:</label>
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

                    <!-- Sección para mostrar el monto total -->
                    <div align="right" class="Estilo9">
                        <label id="lbltotal" name="lbltotal"></label> <!-- Mostramos el monto total -->
                        <input type="hidden" name="txtTotal" id="txtTotal" value="0" /> <!-- Campo oculto para el monto total -->
                        <input type="hidden" name="txtTotalCompra" id="txtTotalCompra" value="" />
                    </div>

                    <!-- Mensaje de error (si es necesario) -->
                    <div id="mensaje" style="display:none; color: red;"></div>

                    <!-- Botón para enviar el formulario -->
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
            url: 'jsp/buscadordetallepago.jsp',
            type: 'post',
            beforeSend: function () {
                //$("#resultado").html("Procesando, espere por favor...");
            },
            success: function (response) {
                $("#id_proveedor").html(response);
            
            }
        });
    }
 
    function dividiralumno(a) {
        if (a) {
            var datos = a.split(',');
            $("#codalumno").val(datos[0]);
            $("#ruc").val(datos[1]);

             // Cargar cuentas pendientes del cliente seleccionado
             cargarCuentaPendiente(datos[0]);
            } else {
              console.error("No hay datos para dividir.");
        }
    }

    function cargarCuentaPendiente(proveedorId) {
        $.ajax({
            data: {listar: 'cargarcuentapendiente', proveedorId: proveedorId},
            url: 'jsp/buscadordetallepago.jsp',
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
            url: 'jsp/buscadordetallepago.jsp',
            type: 'post',
            beforeSend: function () {
                //$("#resultado").html("Procesando, espere por favor...");
            },
            success: function (response) {
                location.href = 'pagos.jsp';
            }
        });

    });
    
    
    
    
    
$("#btn-finalizar").click(function () {
    // Obtenemos todos los checkboxes con la clase "cuentas"
    let cb = document.getElementsByClassName("cuentas");
    let cuentas = [];
    let montoTotal = 0; // Variable para almacenar el monto total

    // Recorremos los checkboxes para agregar los que estén seleccionados
    for (let i = 0; i < cb.length; i++) {
        if (cb[i].checked === true) {
            cuentas.push(cb[i].value);
            let monto = parseFloat(cb[i].getAttribute("data-monto")); // Obtener el monto de cada cuenta
            if (!isNaN(monto)) {
                montoTotal += monto; // Sumar el monto total
            }
        }
    }

    // Limpiamos cualquier mensaje previo
    $("#mensaje").hide().text(""); // Ocultamos y limpiamos el mensaje previo

    // Verificamos si se han seleccionado cuentas
    if (cuentas.length === 0) {
        $("#mensaje").text("Por favor, complete todos los campos.").show(); // Mostramos el mensaje
        setTimeout(function() {
            $("#mensaje").fadeOut(); // Desvanecemos el mensaje después de 3 segundos
        }, 2000); // 3000 milisegundos = 3 segundos
        return; // Detenemos la ejecución
    }

    // Redondear el monto total a un número entero
    montoTotal = Math.round(montoTotal); // Redondeamos a número entero

    // Mostrar el monto total en el campo 'lbltotal'
    $("#lbltotal").text('Monto Total: ' + montoTotal); // Mostrar el monto sin decimales

    // Establecer el valor del monto total en el campo oculto txtTotal
    $("#txtTotal").val(montoTotal); // Guardar el monto total como número entero

    // Mostrar el modal para elegir el método de pago
    $("#agregarMetodoModal").modal("show");

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
                    id_proveedor: $("#codalumno").val(),
                    idabrircaja: $("#idabrircaja").val(),
                    fecharegistro: $("#fecharegistro").val(),
                    numero: $("#numero").val(),
                    idcuentaproveedores: cuentas,
                    metodo_pago: metodo,
                    banco: banco,
                    monto_total: montoTotal // Enviar el monto total como número entero
                },
                url: 'jsp/buscadordetallepago.jsp',
                type: 'post',
                success: function (response) {
                    // Redirigimos a la página "pagos.jsp" si la petición es exitosa
                    location.href = 'pagos.jsp';
                },
                error: function() {
                    // Manejamos cualquier error de la petición
                    $("#mensaje").text("Ocurrió un error al procesar la solicitud. Intente nuevamente.").show();
                    setTimeout(function() {
                        $("#mensaje").fadeOut(); // Desvanecemos el mensaje después de 3 segundos
                    }, 3000); // 3000 milisegundos = 3 segundos
                }
            });

            // Ocultar el modal después de enviar
            $("#agregarMetodoModal").modal("hide");
        } else {
            alert("Por favor, complete todos los campos del método de pago.");
        }
    });
});




</script>
<%@include file="footer.jsp" %>