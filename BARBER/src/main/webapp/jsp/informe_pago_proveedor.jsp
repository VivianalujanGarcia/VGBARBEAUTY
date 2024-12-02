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
            // Preparar la consulta SQL
            String query = "SELECT to_char(v.fecha, 'dd-mm-yyyy') AS fecha_formateada, " +
                           "cl.nombre, cl.ruc, cc.monto, c.numero " +
                           "FROM cuentasproveedores cc " +
                           "JOIN compras v ON cc.idcompras = v.id " +  // Relacionamos cuentasclientes con ventas
                           "JOIN proveedores cl ON v.id_proveedor = cl.id_proveedor " +  // Relacionamos ventas con clientes
                           "JOIN pagos c ON c.idproveedores = cl.id_proveedor " +  // Relacionamos cobros con clientes
                           "WHERE c.estado = 'FINALIZADO' " +
                           "AND v.fecha BETWEEN '" + fechaDesdeStr + "' AND '" + fechaHastaStr + "'";  // Fechas ajustadas con la columna de fecha de la tabla 'ventas'

            // Filtrar por cliente si se proporciona el id_cliente
            if (id_proveedor != null && !id_proveedor.isEmpty()) {
                query += " AND c.idproveedores = '" + id_proveedor + "'";
            }

            query += " GROUP BY v.fecha, cl.nombre, cl.ruc, c.numero, cc.monto";  // Agrupar por los campos necesarios

            // Ejecutar la consulta
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(query);

            // Iterar a través de los resultados
            while (rs.next()) {
%>
<tr>
    <td><%= rs.getString("numero") %></td>  <!-- Número de cobro -->
    <td><%= rs.getString("fecha_formateada") %></td>  <!-- Fecha formateada -->
    <td><%= rs.getString("nombre") + ' ' + rs.getString("ruc") %></td>  <!-- Nombre y CI del cliente -->
    <td><%= rs.getString("monto") %></td>  <!-- Monto de la cuenta cliente -->
</tr>
<%
            }
        } catch (Exception e) {
            out.println("Error PSQL: " + e.getMessage());
        }
    }
%>
