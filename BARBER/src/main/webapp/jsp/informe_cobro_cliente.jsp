<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ include file="conexion.jsp" %>

<%
    // Obtener los parámetros de la solicitud
    String fechaDesdeStr = request.getParameter("fecha_desde");
    String fechaHastaStr = request.getParameter("fecha_hasta");
    String id_cliente = request.getParameter("id_cliente");

    // Validar que las fechas no sean nulas ni vacías
    if ((fechaDesdeStr == null || fechaDesdeStr.isEmpty()) || (fechaHastaStr == null || fechaHastaStr.isEmpty())) {
        out.println("<div class='alert alert-danger'>Error: Debes ingresar ambas fechas.</div>");
    } else {
        try {
            // Preparar la consulta SQL
            String query = "SELECT to_char(v.fecha, 'dd-mm-yyyy') AS fecha_formateada, " +
                           "cl.nombre, cl.ci, cc.monto, c.numero " +
                           "FROM cuentasclientes cc " +
                           "JOIN ventas v ON cc.idventas = v.id " +  // Relacionamos cuentasclientes con ventas
                           "JOIN clientes cl ON v.id_cliente = cl.id_cliente " +  // Relacionamos ventas con clientes
                           "JOIN cobros c ON c.idclientes = cl.id_cliente " +  // Relacionamos cobros con clientes
                           "WHERE c.estado = 'FINALIZADO' " +
                           "AND v.fecha BETWEEN '" + fechaDesdeStr + "' AND '" + fechaHastaStr + "'";  // Fechas ajustadas con la columna de fecha de la tabla 'ventas'

            // Filtrar por cliente si se proporciona el id_cliente
            if (id_cliente != null && !id_cliente.isEmpty()) {
                query += " AND c.idclientes = '" + id_cliente + "'";
            }

            query += " GROUP BY v.fecha, cl.nombre, cl.ci, c.numero, cc.monto";  // Agrupar por los campos necesarios

            // Ejecutar la consulta
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(query);

            // Iterar a través de los resultados
            while (rs.next()) {
%>
<tr>
    <td><%= rs.getString("numero") %></td>  <!-- Número de cobro -->
    <td><%= rs.getString("fecha_formateada") %></td>  <!-- Fecha formateada -->
    <td><%= rs.getString("nombre") + ' ' + rs.getString("ci") %></td>  <!-- Nombre y CI del cliente -->
    <td><%= rs.getString("monto") %></td>  <!-- Monto de la cuenta cliente -->
</tr>
<%
            }
        } catch (Exception e) {
            out.println("Error PSQL: " + e.getMessage());
        }
    }
%>
