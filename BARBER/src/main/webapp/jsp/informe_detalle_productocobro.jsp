<%@ page import="java.sql.*" %> 
<%@ page import="java.util.*" %> 
<%@ include file="conexion.jsp" %>

<%
    // Obtener los parámetros de la solicitud
    String fechaDesdeStr = request.getParameter("fecha_desde");
    String fechaHastaStr = request.getParameter("fecha_hasta");
    String id_proveedor = request.getParameter("id_proveedor");
    String id_producto = request.getParameter("id_producto"); // Agregado el parámetro id_producto

    // Validar que las fechas no sean nulas ni vacías
    if ((fechaDesdeStr == null || fechaDesdeStr.isEmpty()) || (fechaHastaStr == null || fechaHastaStr.isEmpty())) {
        out.println("<div class='alert alert-danger'>Error: Debes ingresar ambas fechas.</div>");
    } else {
        try {
            // Preparar la consulta SQL
            Statement st = conn.createStatement();
            String query = "SELECT DISTINCT c.numero , to_char(v.fecha, 'dd-mm-yyyy') AS fecha_formateada, " +
                           "p.descripcion AS producto, dt.cantidad, " +
                           "cc.monto " +
                           "FROM detallecompras dt " +
                           "JOIN productos p ON dt.id_producto = p.id_producto " +
                           "JOIN compras v ON dt.idcompra = v.id " +
                           "JOIN cuentasproveedores cc ON v.id = cc.idcompras " +  // Relacionamos ventas con cuentasclientes
                           "JOIN pagos c ON c.idproveedores = v.id_proveedor " +  // Relacionamos cobros con clientes
                           "WHERE v.estado = 'Finalizado' " +
                           "AND v.fecha BETWEEN '" + fechaDesdeStr + "' AND '" + fechaHastaStr + "' ";

            // Filtrar por producto si se proporciona el id_producto
            if (id_producto != null && !id_producto.isEmpty()) {
                query += " AND dt.id_producto = '" + id_producto + "' ";
            }

            // Filtrar por cliente si se proporciona el id_cliente
            if (id_proveedor != null && !id_proveedor.isEmpty()) {
                query += " AND v.id_proveedor = '" + id_proveedor + "' ";
            }

            // Ejecutar la consulta
            ResultSet rs = st.executeQuery(query);
            while (rs.next()) {
%>
<tr>
    <td><%= rs.getString("numero") %></td> <!-- Número del cobro -->
    <td><%= rs.getString("fecha_formateada") %></td>
    <td><%= rs.getString("producto") %></td>
    <td><%= rs.getString("cantidad") %></td>
    <td><%= rs.getString("monto") %></td>
</tr>
<%
            }
        } catch (Exception e) {
            out.println("Error PSQL: " + e.getMessage());
        }
    }
%>
