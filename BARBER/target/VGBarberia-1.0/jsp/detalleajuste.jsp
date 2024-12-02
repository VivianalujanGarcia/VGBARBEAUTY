<%@ include file="conexion.jsp" %>
<%    
HttpSession sesion = request.getSession();
int idusuarios = 0; // Inicializa con un valor por defecto
String idusuarioString = (String) sesion.getAttribute("idusuario");
if (idusuarioString != null && !idusuarioString.isEmpty()) {
    try {
        idusuariosfk = Integer.parseInt(idusuariosString);
    } catch (NumberFormatException e) {
        out.println("Error: ID de usuario no válido.");
        return;
    }
} else {
    out.println("Error: ID de usuario no proporcionado.");
    return;
}

if (request.getParameter("listar").equals("cargar")) {
    String productoParam = request.getParameter("codproducto");
    String fecha = request.getParameter("fecha");
    String tipo = request.getParameter("tipo");
    String motivo = request.getParameter("motivo");
    String cant_ajuste = request.getParameter("cant_ajuste");
    String cantidadAjuste = request.getParameter("cant_actual");
   
    
    String[] productoParts = productoParam.split(",");
    String codproducto= productoParts[0].trim(); 

    Statement st = null;
    ResultSet rs = null;
    ResultSet pk = null;
    
    try {
        st = conn.createStatement();
        rs = st.executeQuery("SELECT id FROM ajusteinventario WHERE estado='PENDIENTE'");
        if (rs.next()) {
            st.executeUpdate("INSERT INTO detalleajuste(idajusteinve, idproductos, motivo, cant_ajuste, cant_actual) VALUES('" + rs.getString(1) + "','" + idproductos + "','" + motivo + "','" + cantidad_ajuste + "','" + cantidadAjuste + "')");
        } else {
            st.executeUpdate("INSERT INTO ajustar(fecha, tipo, idusuariosfk) VALUES('" + fecha + "','" + tipo + "', " + idusuariosfk + ")");
            pk = st.executeQuery("SELECT id FROM ajusteinventario WHERE estado='PENDIENTE'");
            if (pk.next()) {
                st.executeUpdate("INSERT INTO detalleajuste(idajusteinve, idproductos, motivo, cant_ajuste, cant_actual) VALUES('" + pk.getString(1) + "','" + idproductos + "','" + motivo + "','" + cantidad_ajuste + "','" + cantidadAjuste + "')");
            }
        }
    } catch (SQLException e) {
        out.println("error PSQL: " + e.getMessage());
    } finally {
        try {
            if (rs != null) rs.close();
            if (pk != null) pk.close();
            if (st != null) st.close();
        } catch (SQLException e) {
            out.println("error closing resources: " + e.getMessage());
        }
    }
    
} else if (request.getParameter("listar").equals("listar")) {
    Statement st = null;
    ResultSet rs = null;
    ResultSet pk = null;
    
    try {
        st = conn.createStatement();
        pk = st.executeQuery("SELECT id FROM ajusteinventario WHERE estado='PENDIENTE'");
        if (pk.next()) {
            rs = st.executeQuery("SELECT dt.id, p.descripcion, p.stock, dt.cant_ajuste, dt.cant_actual FROM detalleajuste dt JOIN productos p ON dt.idproductos = p.id_productos WHERE dt. idajusteinve = '" + pk.getString(1) + "' ORDER BY dt.iddetalleajuste");
            while (rs.next()) {
                String descripcion = rs.getString(2);
                String cantidad = rs.getString(3);
                String cantidad_ajuste = rs.getString(4);
                String cantidad_actual = rs.getString(5);
%>
<tr>
    <td>
        <% if (sesion.getAttribute("rol").equals("ADMINISTRADOR")) {
        %>
        <i class="fa fa-trash" style="color:red" data-toggle="modal" data-target="#exampleModal" onclick="$('#idpk').val(<%= rs.getString(1) %>);"></i>
        <% }
        %>
    </td>
    <td><%= rs.getString(2) %></td>
    <td><%= rs.getString(3) %></td>
    <td><%= rs.getString(4) %></td>
    <td><%= rs.getString(5) %></td>
</tr>
<%
            }
        }
    } catch (SQLException e) {
        out.println("error PSQL: " + e.getMessage());
    } finally {
        try {
            if (rs != null) rs.close();
            if (pk != null) pk.close();
            if (st != null) st.close();
        } catch (SQLException e) {
            out.println("error closing resources: " + e.getMessage());
        }
    }
} else if (request.getParameter("listar").equals("eliminardetalle")) {
    String pk = request.getParameter("pk");
    try {
        Statement st = conn.createStatement();
        st.executeUpdate("DELETE FROM detalleajuste WHERE id='" + pk + "'");
    } catch (SQLException e) {
        out.println("error PSQL: " + e.getMessage());
    }
} else if (request.getParameter("listar").equals("cancelarajuste")) {
    try {
        Statement st = null;
        ResultSet pk = null;
        st = conn.createStatement();
        pk = st.executeQuery("SELECT idajustar FROM ajustar WHERE estado='PENDIENTE'");
        if (pk.next()) {
            st.executeUpdate("UPDATE ajustar SET estado='CANCELADO' WHERE idajustar='" + pk.getString(1) + "'");
            //out.print("Venta cancelada exitosamente");
        }
    } catch (Exception e) {
        out.println("error PSQL: " + e.getMessage());
    }
} else if ("finalizarajuste".equals(request.getParameter("listar"))) {
    try {
        Statement st = conn.createStatement();
        
        // Actualizar estado de los ajustes a FINALIZADO
        ResultSet pk = st.executeQuery("SELECT id FROM ajusteinventario WHERE estado='PENDIENTE'");
        if (pk.next()) {
            int id = pk.getInt(1);
            st.executeUpdate("UPDATE ajusteinventario SET estado='FINALIZADO' WHERE id=" + id);
            
            // Procesar cada detalle del ajuste
            String queryDetalles = "SELECT d.idproductos, d.cant_ajuste, a.tipo " +
                                   "FROM detalleajuste d " +
                                   "JOIN ajusteinventario a ON d.idajusteinve= a.id " +
                                   "WHERE a.estado='FINALIZADO' AND d.idajusteinve=?";
            try (PreparedStatement psDetalles = conn.prepareStatement(queryDetalles)) {
                psDetalles.setInt(1, id);
                ResultSet detalles = psDetalles.executeQuery();
                while (detalles.next()) {
                    int idproductos_serviciosfk = detalles.getInt("idproductos");
                    int cantidad_ajuste = detalles.getInt("cantidad_ajuste");
                    String tipo = detalles.getString("tipo");

                    // Ajustar el stock en la tabla productos_servicios
                    String updateStockQuery;
                    if ("aumento".equals(tipo)) {
                        updateStockQuery = "UPDATE productos SET cantidad = cantidad + ? WHERE id_productos = ?";
                    } else if ("descuento".equals(tipo)) {
                        updateStockQuery = "UPDATE productos SET cantidad = cantidad - ? WHERE id_productos = ?";
                    } else {
                        continue; // Si el tipo no es válido, omite el ajuste
                    }

                    try (PreparedStatement psUpdateStock = conn.prepareStatement(updateStockQuery)) {
                        psUpdateCantidad.setInt(1, cant_ajuste);
                        psUpdateCantidad.setInt(2, id_productos);
                        psUpdateCantidad.executeUpdate();
                    }
                }
            }
        }
    } catch (SQLException e) {
        out.println("Error al finalizar el ajuste: " + e.getMessage());
    }
} else if (request.getParameter("listar").equals("listarajuste")) {
    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();
        rs = st.executeQuery("SELECT a.fecha, a.tipo, d.motivo, a.id FROM ajusteinventario a JOIN detalleajuste d ON d.idajusteinve = a.id WHERE a.estado='FINALIZADO'");
        while (rs.next()) {

%>
<tr>
    <td><% out.print(rs.getString(4)); %></td>
    <td><% out.print(rs.getString(1)); %></td>
    <td><% out.print(rs.getString(2)); %></td>
    <td><% out.print(rs.getString(3)); %></td>
    <td>
        <% if (sesion.getAttribute("rol").equals("ADMINISTRADOR")) {%>
        <button class="btn btn-outline-danger" onclick="$('#idpk').val(<% out.print(rs.getString(4)); %>)" title="Anular" data-toggle="modal" data-target="#exampleModal">
            <img src="images/eliminar.png">
        </button>
        <% }%>
    </td>
</tr>   
<%
            }
        } catch (Exception e) {
            out.println("error PSQL" + e);
        }

} else if (request.getParameter("listar").equals("anularajuste")) {

     try {
        Statement st = conn.createStatement();
        
        // Obtener el ID del ajuste que se va a anular
        int id = Integer.parseInt(request.getParameter("pkd"));
        
        // Cambiar el estado del ajuste a 'ANULADO'
        int rowsAffected = st.executeUpdate("UPDATE ajusteinventario SET estado='ANULADO' WHERE id=" + id);
        
        // Verificar si se actualizó el estado del ajuste
        if (rowsAffected == 0) {
            out.println("<i class='alert alert-warning'>No se encontró el ajuste con ID " + id + " para anular.</i>");
        } else {
            // Procesar cada detalle del ajuste para restablecer el stock
            String queryDetalles = "SELECT d.idproductos, d.cant_ajuste, a.tipo " +
                                   "FROM detalleajuste d " +
                                   "JOIN ajusteinventario a ON d.idajusteinve = a.id " +
                                   "WHERE d.idajusteinve=?";
            try (PreparedStatement psDetalles = conn.prepareStatement(queryDetalles)) {
                psDetalles.setInt(1, id);
                ResultSet detalles = psDetalles.executeQuery();
                
                boolean stockUpdated = false;
                while (detalles.next()) {
                    int idproductos = detalles.getInt("idproductos");
                    int cantidad_ajuste = detalles.getInt("cantidad_ajuste");
                    String tipo = detalles.getString("tipo");

                    // Actualizar el stock en función del tipo de ajuste
                    String updateStockQuery;
                    if ("aumento".equals(tipo)) {
                        updateStockQuery = "UPDATE productos SET cantidad = cantidad - ? WHERE id_producto = ?";
                    } else if ("descuento".equals(tipo)) {
                        updateStockQuery = "UPDATE productos SET cantidad = cantidad + ? WHERE id_producto = ?";
                    } else {
                        out.println("<i class='alert alert-warning'>Tipo de ajuste inválido: " + tipo + "</i>");
                        continue; // Si el tipo no es válido, omite el ajuste
                    }

                    try (PreparedStatement psUpdateStock = conn.prepareStatement(updateStockQuery)) {
                        psUpdatecantidad.setInt(1, cantidad_ajuste);
                        psUpdatecantidad.setInt(2, idproductosk);
                        int updateRows = psUpdateStock.executeUpdate();
                        if (updateRows > 0) {
                            stockUpdated = true;
                        }
                    }
                }
                if (stockUpdated) {
                    out.println("<i class='alert alert-success'>Ajuste anulado y stock restablecido.</i>");
                } else {
                    out.println("<i class='alert alert-info'>No se actualizó el stock.</i>");
                }
            }
        }
    } catch (SQLException e) {
        out.println("<i class='alert alert-danger'>Error al anular el ajuste: " + e.getMessage() + "</i>");
    }
} 



%>

