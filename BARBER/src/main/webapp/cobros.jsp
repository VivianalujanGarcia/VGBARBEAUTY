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
                color: #6b5b95; /* Color del bot�n */
                cursor: pointer;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <strong> No se puede ingresar a COBROS porque no hay una caja abierta.</strong>
            </div>
        </div>
        <script>
            // Redirigir despu�s de mostrar el mensaje
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

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ include file="header.jsp" %>

<style>
        body {
            background-color: #FFFFFF; /* Color de fondo */
            font-family: 'Karla', sans-serif; /* Fuente principal */
            margin: 0;
            padding: 0;
        }
 </style>
<script src="ajax/cobros.js"></script>

<div class="container-fluid mt-5">
    <div class="col-12">
        <div class="card">
            <div class="card-header">
               
                <button type="button" onclick="location.href = 'detcobros.jsp'" class="btn btn-primary">Nuevo Cobro</button>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                        <button class="btn btn-outline-secondary" data-ciudades="1" title="Imprimir" onclick="window.open('jsp/ListadoCobros.jsp', '_blank')">
    Imprimir Listado General <img src="img/impresora.png" title="Imprimir">
</button>
                    <table class="table" id="resultado" style="min-width: 100px; color: black;">
                        <thead>
                            <tr>
                                <th style="display:none;">ID</th>
                                <th>N°</th>
                                <th>FECHA</th>
                                <th>CLIENTE</th>
                                <th>RUC</th>
                                <th>ESTADO</th>
                                <th>ACCION</th>
                        </thead>
                        <tbody id="resultadoscobros">
                        </tbody>
                    </table>
                </div>
                <div id="pagination" class="mt-3"></div>
            </div>
        </div>
    </div>
</div>

<!-- Modal -->
<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Anular Cobro</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                ¿Está seguro que desea anular el cobro?
                <input type="hidden" name="idpk" id="idpk" />
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">NO</button>
                <button type="button" class="btn btn-primary" id="eliminar-registro-cobro">SI</button>
            </div>
        </div>
    </div>
</div>
<!--**********************************
    Modal Anular
***********************************-->



<div id="Imprimir" class="modal fade" role="dialog">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-secondary text-white">
                <h4 class="modal-title text-white">Imprimir</h4>
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
  
    function anularCobro(id) {
       // Asigna el ID al input oculto
      $("#idpk").val(id);
    }
    function listadocobrosajax() {
        $.ajax({
            data: { listar: 'listarcobro' },
            url: 'jsp/buscadordetallecobro.jsp',
            type: 'post',
            success: function (response) {
                $("#resultadoscobros").html(response);
            },
            error: function (xhr, status, error) {
                console.error("Error en la solicitud AJAX:", error);
                console.error("Detalles del error:", xhr.responseText);
                $("#resultadoscobros").html("Error al cargar los datos.");
            }
        });
    }

    </script>
<%@ include file="footer.jsp" %>
