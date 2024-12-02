<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ include file="conexion.jsp" %>

<%
    // Obtener los par�metros de la solicitud
    String fechaDesdeStr = request.getParameter("fecha_desde");
    String fechaHastaStr = request.getParameter("fecha_hasta");
    String id_producto = request.getParameter("id_producto");

    // Validar que las fechas no sean nulas ni vac�as
    if ((fechaDesdeStr == null || fechaDesdeStr.isEmpty()) || (fechaHastaStr == null || fechaHastaStr.isEmpty())) {
        out.println("<div class='alert alert-danger'>Error: Debes ingresar ambas fechas.</div>");
    } else {
        try {
            // Preparar la consulta SQL
            Statement st = conn.createStatement();
            String query = "SELECT v.numero, to_char(v.fecha, 'dd-mm-yyyy') AS fecha_formateada, p.descripcion, dt.precio, dt.cantidad " +
                           "FROM detalleventas dt " +
                           "JOIN productos p ON dt.id_producto = p.id_producto " +
                           "JOIN ventas v ON dt.idventa = v.id " +
                           "WHERE  v.estado = 'Finalizado' AND v.fecha BETWEEN '" + fechaDesdeStr + "' AND '" + fechaHastaStr + "' ";

            // Filtrar por producto si se proporciona el id_producto
            if (id_producto != null && !id_producto.isEmpty()) {
                query += " AND dt.id_producto = '" + id_producto + "' ";
            }

            // Ejecutar la consulta
            ResultSet rs = st.executeQuery(query);
            while (rs.next()) {
%>
<tr>
    <td><%= rs.getString("numero") %></td>
    <td><%= rs.getString("fecha_formateada") %></td>
    <td><%= rs.getString("descripcion") %></td>
    <td><%= rs.getString("cantidad") %></td>
    <td><%= rs.getString("precio") %></td>
</tr>
<%
            }
        } catch (Exception e) {
            out.println("Error PSQL: " + e.getMessage());
        }
    }
%>
