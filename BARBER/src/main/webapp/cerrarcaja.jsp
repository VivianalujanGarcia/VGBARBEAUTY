<%@ include file="header.jsp" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.*" %>

<%
    // Obtener la fecha actual
    Date fechaActual = new Date();
    SimpleDateFormat formateadorFecha = new SimpleDateFormat("dd-MM-yyyy");
    String fechaFormateada = formateadorFecha.format(fechaActual);

    // Definir variables de monto
    double montoCaja = 0.0;
    int montoInicial = 0;  // Monto inicial que se establece cuando se abre la caja

    Connection conn = null; // Asegúrate de inicializar tu conexión en algún lugar
    Statement st = null;
    ResultSet rs = null;

    try {
        // Aquí debes asegurar que `conn` esté correctamente inicializado
        conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/VGBarberia", "postgres", "1");
        st = conn.createStatement();
        // Obtener el monto inicial de la caja abierta
        String sqlApertura = "SELECT monto FROM abrircaja WHERE estado='ABIERTO' LIMIT 1";  // Solo recuperamos una caja abierta
        rs = st.executeQuery(sqlApertura);

        if (rs.next()) {
            montoInicial = rs.getInt("monto");  // Almacenamos el monto de apertura
        } else {
            // Si no hay caja abierta, mostramos un error
            out.print("No hay ninguna caja abierta.");
            return;
        }
        // Consulta para obtener los totales de ingresos y egresos
        String sql = "WITH compras_ventas AS (SELECT id, fecha, id_proveedor as cliente_proveedor, total as total_transaccion, 'Compra' as tipo_transaccion, numero, total AS egreso, 0 AS ingreso FROM compras WHERE estado='Finalizado' AND condicion='contado' UNION ALL SELECT id, fecha, id_cliente as cliente_proveedor, total as total_transaccion, 'Venta' as tipo_transaccion, numero, 0 AS egreso, total as ingreso FROM ventas WHERE estado='Finalizado' AND condicion='contado' UNION ALL SELECT p.id, cc.fecha as fecha, cc.id_proveedor as cliente_proveedor, p.monto as total_transaccion, 'Pago' as tipo_transaccion, p.nrocuota as numero, p.monto AS egreso, 0 AS ingreso FROM cuentasproveedores p INNER JOIN compras cc on p.idcompras=cc.id UNION ALL SELECT c.id, v.fecha as fecha, v.id_cliente as cliente_proveedor, c.monto as total_transaccion, 'Cobro' as tipo_transaccion, c.nrocuota as numero, 0 AS egreso, c.monto as ingreso FROM cuentasclientes c INNER JOIN ventas v on c.idventas=v.id) SELECT (SELECT COALESCE(SUM(ingreso), 0) FROM compras_ventas) AS total_ingreso, (SELECT COALESCE(SUM(egreso), 0) FROM compras_ventas) AS total_egreso, (SELECT COALESCE(SUM(ingreso), 0) - COALESCE(SUM(egreso), 0) FROM compras_ventas) AS diferencia;";

        rs = st.executeQuery(sql);

        if (rs.next()) {
            double totalIngreso = rs.getDouble("total_ingreso");
            double totalEgreso = rs.getDouble("total_egreso");
            montoCaja = montoInicial + totalIngreso - totalEgreso;  // El monto final será el inicial más los movimientos
        }
    } catch (SQLException e) {
        out.print("Error al calcular el monto en caja: " + e.getMessage());
    } finally {
        try {
            if (rs != null) rs.close();
            if (st != null) st.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            out.print("Error al cerrar recursos: " + e.getMessage());
        }
    }
    // Redondear el monto a un número entero
    montoCaja = Math.round(montoCaja);  // Redondeamos el valor a un número entero

%>

<html>
<head>
    <title>Cierre de Caja</title>
    <script src="ajax/cerrarcaja.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h1 {
            text-align: center;
            color: #333;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #555;
        }
        .form-group input {
            width: 100%;
            padding: 10px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .btn {
            display: block;
            width: 100%;
            padding: 10px;
            font-size: 16px;
            border: none;
            border-radius: 4px;
            color: white;
            cursor: pointer;
            background-color: #28a745;
        }
        .btn:hover {
            background-color: #218838;
        }
        .alert {
            margin-top: 20px;
            padding: 15px;
            border-radius: 4px;
            color: white;
        }
        .alert-success {
            background-color: #28a745;
        }
        .alert-danger {
            background-color: #dc3545;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Cierre de Caja</h1>
        <form id="form">
            <input type="hidden" id="listar" name="listar" value="cargar"/>
            <div class="form-group">
                <label for="fecha">Fecha:</label>
                <input type="text" id="fecha" name="fecha" value="<%= fechaFormateada %>" readonly>
            </div>
            <div class="form-group">
                <input type="hidden" id="idabrircaja" name="idabrircaja" readonly required>
            </div>
            <div class="form-group">
                <label for="monto">Monto Final en Caja:</label>
                <!-- El monto calculado se mostrará aquí automáticamente -->
              <input type="number" id="monto" name="monto" value="<%= montoCaja %>" required readonly>
            </div>
          
            <input type="button" id="cerrarcaja" class="btn" value="Cerrar Caja">
        </form>
        <div id="mensajeAlerta" class="alert" style="display: none;"></div>
    </div>
</body>
</html>
 <script>
        $(document).ready(function () {
            // Mostrar el monto calculado como número entero
            var totalIngreso = <%= montoCaja %>;

            // Mostrar el monto en la caja como número entero
            $("#monto").val(totalIngreso);
        });
    </script>
<%@ include file="footer.jsp" %>
