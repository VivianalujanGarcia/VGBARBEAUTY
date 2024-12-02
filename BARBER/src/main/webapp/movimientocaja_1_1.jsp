<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>

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
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Movimiento de Caja - VGBarberia</title>
    <style>
        body {
            background-color: #f5f5f5;
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
        }
        .container {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #fff;
        }
        .alert {
            max-width: 600px;
            padding: 20px;
            background-color: #ffcccb;
            color: #d9534f;
            text-align: center;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .btn-close {
            background: none;
            border: none;
            font-size: 1.5rem;
            color: #d9534f;
            cursor: pointer;
        }
        /* Redirigir a la página principal después de 2 segundos */
        @keyframes fadeOut {
            0% { opacity: 1; }
            100% { opacity: 0; }
        }
        .fade-out {
            animation: fadeOut 2s forwards;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="alert fade-out" role="alert">
            <strong>No se puede ingresar al movimiento de caja porque no hay una caja abierta.</strong>
            <button class="btn-close" onclick="window.location.href='dashboard.jsp'">&times;</button>
        </div>
    </div>
    <script>
        setTimeout(function () {
            window.location.href = 'dashboard.jsp';
        }, 2000); 
    </script>
</body>
</html>
<%
        return; 
    }
%>

<%@ include file="header.jsp" %>
<script src="ajax/movimientos.js"></script>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Movimiento de Caja - VGBarberia</title>
    <style>
        body {
            background-color: #f5f5f5;
            font-family: 'Arial', sans-serif;
            color: #333;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 90%;
            max-width: 900px;
            margin: 20px auto;
        }
        .header {
            text-align: center;
            color: #6b5b95;
            margin-bottom: 30px;
        }
        .card {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
        }
        .form-group {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 15px;
        }
        .form-group label {
            font-weight: bold;
            color: #555;
            flex: 1;
        }
        .form-group input {
            flex: 2;
            padding: 8px;
            border-radius: 5px;
            border: 1px solid #ddd;
        }
        .search-bar {
            margin-top: 20px;
            display: flex;
            justify-content: flex-end;
        }
        .search-bar input {
            padding: 10px;
            width: 200px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 10px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #6b5b95;
            color: #fff;
        }
        .total-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px;
            background-color: #6b5b95;
            color: #fff;
            border-radius: 5px;
            margin-top: 20px;
        }
        .btn {
            background-color: #6b5b95;
            color: #fff;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .alert {
            padding: 15px;
            background-color: #ffcccb;
            color: red;
            text-align: center;
            border-radius: 5px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="header">
        <h2>VGBarberia - Movimiento de Caja</h2>
    </div>

    

     <!-- Tabla de Movimientos -->
    <div class="card table-container">
        <table>
            <thead>
                <tr>
                    <th>Venta</th>
                    <th>Compra</th>
                    <th>Cobro</th>
                    <th>Pago</th>

                  
                   
                </tr>
            </thead>
            <tbody id="resultados">
                <!-- Aquí se actualizarán los datos dinámicamente con AJAX -->
            </tbody>
            
        </table>
    </div>

    <!-- Totales -->
     <!-- Tabla de Movimientos -->
    <div class="card table-container">
        <table>
            <thead>
             <tbody>
                  <tr>
                    <th>Total Ventas</th>
                    <th>Total Compras</th>
                    <th>Total Cobros</th>
                    <th>Total Pagos</th>
                </tr>
                <tr>
                    
                    <th colspan="3">Monto total en la caja:</th>
                    <td>0</td>
                </tr>
                <tr>
                    <th colspan="3">Resultado:</th>
                    <td>0</td>
                </tr>
            </tbody>
  </thead>
        </div>
          </tbody>
            
        </table>
    </div>

       
    

<%@ include file="footer.jsp" %>

