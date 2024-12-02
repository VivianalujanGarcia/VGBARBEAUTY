<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>



<%
    Connection conn = null;
    Statement st = null;
    ResultSet rs = null;
    boolean cajaAbierta = false;

    try {
        Class.forName("org.postgresql.Driver");
        conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/VGBarberia", "postgres", "1");

        st = conn.createStatement();
        rs = st.executeQuery("SELECT * FROM abrircaja WHERE estado = 'ABIERTO'");
        if (rs.next()) {
            cajaAbierta = true;
        }
    } catch (Exception e) {
        e.printStackTrace();
%>

<%
        return;
    } finally {
        try {
            if (rs != null) rs.close();
            if (st != null) st.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    if (!cajaAbierta) {
%>
<html>
    <head>
        <style>
            .container {
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                background-color: #370067; /* Color de fondo lila claro */
            }
            .alert {
                max-width: 600px;
                margin: 0 auto;
                padding: 20px;
                border-radius: 8px;
                background-color: #f3e8ff; /* Fondo del mensaje morado claro */
                color: #6b5b95; /* Color del texto morado oscuro */
                text-align: center;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }
            .btn-close {
                background: none;
                border: none;
                font-size: 1.5rem;
                color: #6b5b95; /* Color del bot?n */
                cursor: pointer;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <strong> No se puede ingresar a la factura compra porque no hay una caja abierta.</strong>
            </div>
        </div>
        <script>
            // Redirigir despu?s de mostrar el mensaje
            setTimeout(function () {
                location.href = 'dashboard.jsp';
            }, 2000); 
        </script>
    </body>
</html>
<%
        return; 
    }
%>


<%@ include file="header.jsp" %>
<style>
        body {
            background-color: #FFFFFF; /* Color de fondo */
            font-family: 'Karla', sans-serif; /* Fuente principal */
            margin: 0;
            padding: 0;
        }
 </style>
<div class="content-wrapper">
    <section class="content">
        <h1>Listar compras<button class="btn btn-outline-secondary" data-ciudades="1" title="Imprimir" data-toggle="modal" data-target="#Imprimirl">
    Imprimir Listado General <img src="img/impresora (1).png" title="Imprimir"></h1>
        <button type="button" onclick="location.href = 'detcompras.jsp'" class="btn btn-primary">Nueva compra</button>
        <table class="table">
            <thead>
                <tr>
                    <th scope="col">#</th>
                    <th scope="col">Fecha</th>
                    <th scope="col">Proveedor</th>
                    <th scope="col">Total</th>
                    <th scope="col">Condición</th>
                    <th scope="col">Acción</th>
                </tr>
            </thead>
            <tbody id="resultadoscompras">

            </tbody>
        </table>
    </section>
</div>

<!-- Modal -->
<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Eliminar compra</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                ¿Está seguro que desea eliminar la compra?
                <input type="hidden" name="idpk" id="idpk" />
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">NO</button>
                <button type="button" class="btn btn-primary" id="confirmar-eliminar-compra">SI</button>
            </div>
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

<script>
    $(document).ready(function () {
        listarcompra();
    });

    function listarcompra() {
        $.ajax({
            data: { listar: 'listarcompra' },
            url: 'jsp/insercioncompras.jsp',
            type: 'post',
            beforeSend: function () {
                // Mostrar indicador de carga si lo deseas
            },
            success: function (response) {
                $("#resultadoscompras").html(response);

                // Reasignar eventos de clic después de cargar el contenido dinámico
                asignarEventosEliminar();
            },
            error: function (xhr, status, error) {
                console.error('Error al cargar las compras:', error);
            }
        });
    }
    $("#imprimirtodo").on('click', function () {
        var pk = $("#pkim").val();
        window.open('jsp/reportecompra.jsp?pkim=' + pk, '_blank');
        $.ajax({
            data: {listar: ' ', pkim: pk},
            url: 'jsp/insercioncompras.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                mostrarMensaje(response);
                listarcompra();
                $("#Imprimir").modal("hide");
                $("#mensaje").fadeOut(2000, function () {
                    $("#mensaje").html("");
                });
            },
            error: function (xhr, status, error) {
                console.error("Error en la solicitud AJAX:", status, error);
                $("#mensaje").html("Error al procesar la solicitud.");
            }
        });
    });
    
    
    $("#imprimi").on('click', function () {
        var pkim = $("pkim").val();
        window.open('jsp/ListadoCompra.jsp?pkim=' + pkim, '_blank');

        $.ajax({
            data: {listar: ' ', pkim: pkim},
            url: 'jsp/insercioncompras.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                mostrarMensaje(response);
                listarcompra();
                $("#Imprimirl").modal("hide");
                $("#mensaje").fadeOut(2000, function () {
                    $("#mensaje").html("");
                });
            },
            error: function (xhr, status, error) {
                console.error("Error en la solicitud AJAX:", status, error);
                $("#mensaje").html("Error al procesar la solicitud.");
            }
        });

    });

    // Función para asignar eventos de clic a los botones de eliminar
    function asignarEventosEliminar() {
        $(".eliminar-compra").click(function () {
            var idCompra = $(this).data("id");
            $("#idpk").val(idCompra); // Establecer el id de la compra en el campo oculto del modal
        });

        // Evento para confirmar la eliminación de la compra
        $("#confirmar-eliminar-compra").click(function () {
            var pkd = $("#idpk").val();
            $.ajax({
                data: { listar: 'anularcompra', pkd: pkd },
                url: 'jsp/insercioncompras.jsp',
                type: 'post',
                beforeSend: function () {
                    // Mostrar indicador de carga si lo deseas
                },
                success: function (response) {
                    listarcompra(); // Actualizar la lista de compras después de eliminar
                    $("#exampleModal").modal("hide"); // Ocultar el modal después de eliminar
                },
                error: function (xhr, status, error) {
                    console.error('Error al eliminar la compra:', error);
                }
            });
        });
    }
</script>

<%@ include file="footer.jsp" %>
