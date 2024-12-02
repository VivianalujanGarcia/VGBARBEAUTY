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
            // Preparar la consulta SQL dependiendo de si se seleccionó un cliente o no
            Statement st = conn.createStatement();
            String query = "SELECT to_char(v.fecha, 'dd-mm-yyyy') AS fecha_formateada, a.nombre, a.ci, v.total, v.numero " +
                           "FROM ventas v JOIN clientes a ON v.id_cliente = a.id_cliente " +
                           "WHERE v.estado = 'Finalizado' AND v.fecha BETWEEN '" + fechaDesdeStr + "' AND '" + fechaHastaStr + "'";

            // Filtrar por cliente si se proporciona el id_cliente
            if (id_cliente != null && !id_cliente.isEmpty()) {
                query += " AND v.id_cliente = '" + id_cliente + "'";
            }

            ResultSet rs = st.executeQuery(query);
            while (rs.next()) {
                // Mostrar los resultados de la consulta
%>
<tr>
    <td><%= rs.getString(5) %></td>
    <td><%= rs.getString(1) %></td>
    <td><%= rs.getString(2) + ' ' + rs.getString(3) %></td>
    <td><%= rs.getString(4) %></td>
</tr>
<%
            }
        } catch (Exception e) {
            out.println("Error PSQL: " + e.getMessage());
        }
    }
%>
