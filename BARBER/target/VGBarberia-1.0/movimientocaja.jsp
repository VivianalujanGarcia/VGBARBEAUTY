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
<script src="ajax/movimientos.js"></script>

<div class="container-fluid mt-5">
    <div class="col-12">
        <div class="card">
            
            <div class="card-body">
                <div class="table-responsive">
                      
                    <table class="table" id="resultado" style="min-width: 100px; color: black;">
                        <thead>
                            <tr>
                                <th style="display:none;">ID</th>
                                <th>Venta N°</th>
                                <th>Compra N°</th>
                                <th>Cobro N°</th>
                                <th>Pago N°</th>
                                <th style="text-align: center;">ACCION</th>
                        </thead>
                        <tbody id="resultadosmovimientos">
                        </tbody>
                    </table>
                </div>
                <div id="pagination" class="mt-3"></div>
            </div>
        </div>
    </div>
</div>

<!--**********************************
    Modal Anular
***********************************-->


<!--**********************************
    Modal Imprimir Reporte General 
***********************************-->


<script>
  
   
    function listadomovimientoajax() {
        $.ajax({
            data: { listar: 'listarmovimiento' },
            url: 'jsp/listarMovimientos.jsp',
            type: 'post',
            success: function (response) {
                $("#resultadosmovimientos").html(response);
            },
            error: function (xhr, status, error) {
                console.error("Error en la solicitud AJAX:", error);
                console.error("Detalles del error:", xhr.responseText);
                $("#resultadosmovimientos").html("Error al cargar los datos.");
            }
        });
    }

    </script>
<%@ include file="footer.jsp" %>
