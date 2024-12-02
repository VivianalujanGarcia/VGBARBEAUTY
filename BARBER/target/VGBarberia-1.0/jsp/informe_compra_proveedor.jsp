<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ include file="conexion.jsp" %>

<%
    // Obtener los parámetros de la solicitud
    String fechaDesdeStr = request.getParameter("fecha_desde");
    String fechaHastaStr = request.getParameter("fecha_hasta");
    String id_proveedor = request.getParameter("id_proveedor");

    // Validar que las fechas no sean nulas ni vacías
    if ((fechaDesdeStr == null || fechaDesdeStr.isEmpty()) || (fechaHastaStr == null || fechaHastaStr.isEmpty())) {
        out.println("<div class='alert alert-danger'>Error: Debes ingresar ambas fechas.</div>");
    } else {
        try {
            // Preparar la consulta SQL dependiendo de si se seleccionó un proveedor o no
            Statement st = conn.createStatement();
            String query = "SELECT to_char(c.fecha, 'dd-mm-yyyy') AS fecha_formateada, p.nombre, p.ruc, c.total, c.numero " +
                           "FROM compras c JOIN proveedores p ON c.id_proveedor = p.id_proveedor " +
                           "WHERE c.estado = 'Finalizado' AND c.fecha BETWEEN '" + fechaDesdeStr + "' AND '" + fechaHastaStr + "'";

            // Filtrar por proveedor si se proporciona el id_proveedor
            if (id_proveedor != null && !id_proveedor.isEmpty()) {
                query += " AND c.id_proveedor = '" + id_proveedor + "'";
            }

            ResultSet rs = st.executeQuery(query);
            while (rs.next()) {
                // Mostrar los resultados de la consulta
%>
<tr>
    <td><%= rs.getString(5) %></td>  <!-- Número de compra -->
    <td><%= rs.getString(1) %></td>  <!-- Fecha de compra formateada -->
    <td><%= rs.getString(2) + ' ' + rs.getString(3) %></td> <!-- Nombre y CI del proveedor -->
    <td><%= rs.getString(4) %></td>  <!-- Total de la compra -->
</tr>
<%
            }
        } catch (Exception e) {
            out.println("Error PSQL: " + e.getMessage());
        }
    }
%>
