<%@ include file="conexion.jsp" %>
<%
    String fechaDesde = request.getParameter("fecha_desde");
    String fechaHasta = request.getParameter("fecha_hasta");

    // Validar si las fechas no están vacías o nulas
    if ((fechaDesde == null || fechaDesde.isEmpty()) || (fechaHasta == null || fechaHasta.isEmpty())) {
        out.println("<div class='alert alert-danger'>Error: Debes ingresar ambas fechas.</div>");
    } else {
        if (request.getParameter("listar") != null && request.getParameter("listar").equals("listarventa")) {
            try {
                Statement st = conn.createStatement();
                String query = "SELECT to_char(v.fecha, 'dd-mm-yyyy') AS fecha_formateada, a.nombre, a.ci, v.total, v.id " +
                               "FROM ventas v JOIN clientes a ON v.id_cliente = a.id_cliente " +
                               "WHERE v.estado = 'Anulado' AND v.fecha BETWEEN '" + fechaDesde + "' AND '" + fechaHasta + "'";

                ResultSet rs = st.executeQuery(query);
                while (rs.next()) {
%>
<tr>
    <td><%= rs.getString(5) %></td>
    <td><%= rs.getString(1) %></td>
    <td><%= rs.getString(2)%></td>
    <td><%= rs.getString(3) %></td>
    <td><%= rs.getString(4) %></td>
</tr>   
<%
                }
            } catch (Exception e) {
                out.println("Error PSQL: " + e.getMessage());
            }
        }
    }
%>
