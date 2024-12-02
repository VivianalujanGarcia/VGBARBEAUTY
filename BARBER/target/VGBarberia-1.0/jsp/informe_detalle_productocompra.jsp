<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ include file="conexion.jsp" %>

<%
    // Obtener los parámetros de la solicitud
    String fechaDesdeStr = request.getParameter("fecha_desde");
    String fechaHastaStr = request.getParameter("fecha_hasta");
    String id_producto = request.getParameter("id_producto");

    // Validar que las fechas no sean nulas ni vacías
    if ((fechaDesdeStr == null || fechaDesdeStr.isEmpty()) || (fechaHastaStr == null || fechaHastaStr.isEmpty())) {
        out.println("<div class='alert alert-danger'>Error: Debes ingresar ambas fechas.</div>");
    } else {
        try {
            // Preparar la consulta SQL
            Statement st = conn.createStatement();
            String query = "SELECT v.numero, to_char(v.fecha, 'dd-mm-yyyy') AS fecha_formateada, " +
                           "p.descripcion, dt.precio, dt.cantidad " +
                           "FROM detallecompras dt " +
                           "JOIN productos p ON dt.id_producto = p.id_producto " +
                           "JOIN compras v ON dt.idcompra = v.id " +
                           "WHERE v.estado = 'Finalizado' AND v.fecha BETWEEN '" + fechaDesdeStr + "' AND '" + fechaHastaStr + "'";

            // Filtrar por producto si se proporciona el id_producto
            if (id_producto != null && !id_producto.isEmpty()) {
                query += " AND dt.id_producto = '" + id_producto + "' ";
            }

            // Ejecutar la consulta
            ResultSet rs = st.executeQuery(query);
            while (rs.next()) {
%>
<tr>
    <td><%= rs.getString("numero") %></td> <!-- Número de la compra -->
    <td><%= rs.getString("fecha_formateada") %></td> <!-- Fecha de compra -->
    <td><%= rs.getString("descripcion") %></td> <!-- Descripción del producto -->
    <td><%= rs.getString("cantidad") %></td> <!-- Cantidad comprada -->
    <td><%= rs.getString("precio") %></td> <!-- Precio del producto -->
</tr>
<%
            }
        } catch (Exception e) {
            out.println("Error PSQL: " + e.getMessage());
        }
    }
%>
