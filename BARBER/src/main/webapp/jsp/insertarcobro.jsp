<%@ include file="../jsp/conexion.jsp" %>
<%
    HttpSession sesion = request.getSession();
    int idusuario = 0;
    String mensajeValidacion = "";

    // Validar si el usuario está autenticado
    if (sesion.getAttribute("id") != null) {
        idusuario = Integer.parseInt(sesion.getAttribute("id").toString());
    } else {
        out.print("Usuario no autenticado. Por favor, inicie sesión.");
        return;
    }

    String listar = request.getParameter("listar");

    if (listar != null && listar.equals("cargar")) {
        // Cargar ajuste
        String codproducto = request.getParameter("codproducto");
        String fecharegistro = request.getParameter("fecharegistro");
        String tipo = request.getParameter("tipo");
        String motivo = request.getParameter("motivo");
        String cant_ajuste = request.getParameter("cant_ajuste");

        if (codproducto == null || codproducto.isEmpty() || 
            fecharegistro == null || fecharegistro.isEmpty() || 
            tipo == null || tipo.isEmpty() || 
            motivo == null || motivo.isEmpty() || 
            cant_ajuste == null || cant_ajuste.isEmpty()) {
            mensajeValidacion = "<i class='alert alert-danger'>Por favor, complete todos los campos correctamente.</i>";
        } else {
            Statement st = null;
            ResultSet rs = null;
            ResultSet pk = null;

            try {
                st = conn.createStatement();
                rs = st.executeQuery("SELECT id FROM ajusteinventario WHERE estado='PENDIENTE'");

                if (rs.next()) {
                    // Sumar o restar la cantidad según el tipo
                    int cantidadAjuste = Integer.parseInt(cant_ajuste);
                    if ("descuento".equals(tipo.toLowerCase())) {
                        cantidadAjuste = -cantidadAjuste; // Convertir a negativo si es descuento
                    }

                    st.executeUpdate("INSERT INTO detalleajuste(idajusteinve, idproductos, motivo, cant_ajuste) " +
                                     "VALUES('" + rs.getString(1) + "','" + codproducto + "','" + motivo + "','" + cantidadAjuste + "')");
                    mensajeValidacion = "<i class='alert alert-success'>Detalle cargado.</i>";
                } else {
                    st.executeUpdate("INSERT INTO ajusteinventario(fecha, tipo, idusuarios, estado) " +
                                     "VALUES('" + fecharegistro + "','" + tipo + "', " + idusuario + ", 'PENDIENTE')");
                    pk = st.executeQuery("SELECT id FROM ajusteinventario WHERE estado='PENDIENTE'");
                    if (pk.next()) {
                        // Sumar o restar la cantidad según el tipo
                        int cantidadAjuste = Integer.parseInt(cant_ajuste);
                        if ("descuento".equals(tipo.toLowerCase())) {
                            cantidadAjuste = -cantidadAjuste; // Convertir a negativo si es descuento
                        }

                        st.executeUpdate("INSERT INTO detalleajuste(idajusteinve, idproductos, motivo, cant_ajuste) " +
                                         "VALUES('" + pk.getString(1) + "','" + codproducto + "','" + motivo + "','" + cantidadAjuste + "')");
                        mensajeValidacion = "<i class='alert alert-success'>Ajuste cargado.</i>";
                    } else {
                        mensajeValidacion = "<i class='alert alert-danger'>No se pudo crear el ajuste pendiente.</i>";
                    }
                }
            } catch (SQLException e) {
                mensajeValidacion = "<i class='alert alert-danger'>Error PSQL: " + e.getMessage() + "</i>";
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (pk != null) pk.close();
                    if (st != null) st.close();
                } catch (SQLException e) {
                    mensajeValidacion = "<i class='alert alert-danger'>Error cerrando recursos: " + e.getMessage() + "</i>";
                }
            }
        }
    } else if (listar != null && listar.equals("listar")) {
        // Listar ajustes
        Statement st = null;
        ResultSet rs = null;

        try {
            st = conn.createStatement();
            String query = "SELECT dt.id, p.descripcion, p.cantidad AS cantidad_actual, dt.cant_ajuste, (p.cantidad + dt.cant_ajuste) AS cantidad_final " +
                           "FROM detalleajuste dt " +
                           "JOIN productos p ON dt.idproductos = p.id_producto " +
                           "JOIN ajusteinventario ai ON dt.idajusteinve = ai.id " +
                           "WHERE ai.estado='PENDIENTE'";
            rs = st.executeQuery(query);

            if (!rs.isBeforeFirst()) {
                out.println("<tr><td colspan='6' class='alert alert-warning'>No hay ajustes de inventario pendientes.</td></tr>");
            } else {
                while (rs.next()) {
                    String descripcion = rs.getString("descripcion");
                    int cantidadActual = rs.getInt("cantidad_actual");
                    int cantidadAjuste = rs.getInt("cant_ajuste");
                    int cantidadFinal = rs.getInt("cantidad_final");

%>
<tr>
    <% if (sesion.getAttribute("rol").equals("ADMINISTRADOR")) { %>
        <td>
            <button type="button" class="btn btn-outline-danger" style="color:red" data-toggle="modal" data-target="#exampleModal" onclick="$('#idpk').val(<%= rs.getString(1) %>);"> 
            <img src="img/papelera-de-reciclaje.png"></button>
        </td>
    <% } %>
    <td><%= descripcion %></td>
    <td><%= cantidadActual %></td>
    <td><%= cantidadAjuste %></td>
    <td><%= cantidadFinal %></td>
</tr>
<%
                }
            }
        } catch (SQLException e) {
            out.println("<i class='alert alert-danger'>Error PSQL: " + e.getMessage() + "</i>");
        } finally {
            try {
                if (rs != null) rs.close();
                if (st != null) st.close();
            } catch (SQLException e) {
                out.println("<i class='alert alert-danger'>Error cerrando recursos: " + e.getMessage() + "</i>");
            }
        }
    } else if (listar != null && listar.equals("eliminardetalle")) {
        // Eliminar detalle de ajuste
        String detallePk = request.getParameter("pk");
        Statement st = null;

        try {
            st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT id FROM detalleajuste WHERE id='" + detallePk + "'");
            if (rs.next()) {
                st.executeUpdate("DELETE FROM detalleajuste WHERE id='" + detallePk + "'");
                mensajeValidacion = "<i class='alert alert-success'>Detalle eliminado correctamente.</i>";
            } else {
                mensajeValidacion = "<i class='alert alert-danger'>No se encontró el detalle con el ID proporcionado.</i>";
            }
            rs.close();
        } catch (SQLException e) {
            mensajeValidacion = "<i class='alert alert-danger'>Error PSQL: " + e.getMessage() + "</i>";
        } finally {
            try {
                if (st != null) st.close();
            } catch (SQLException e) {
                mensajeValidacion = "<i class='alert alert-danger'>Error cerrando recursos: " + e.getMessage() + "</i>";
            }
        }
    } else if (listar.equals("finalizarajuste")) {
        // Finalizar ajuste
        pkResultSet = st.executeQuery("SELECT id FROM ajusteinventario WHERE estado='pendiente'");
        if (pkResultSet.next()) {
        int idAjuste = pkResultSet.getInt(1);
        Statement st = null;
       
        try {
            st = conn.createStatement();
            st.executeUpdate("UPDATE ajusteinventario SET estado='FINALIZADO'  WHERE id='" + idAjuste + "'");
            mensajeValidacion = "<i class='alert alert-success'>Ajuste finalizado correctamente.</i>";
        } catch (SQLException e) {
            mensajeValidacion = "<i class='alert alert-danger'>Error PSQL: " + e.getMessage() + "</i>";
        } finally {
            try {
                if (st != null) st.close();
            } catch (SQLException e) {
                mensajeValidacion = "<i class='alert alert-danger'>Error cerrando recursos: " + e.getMessage() + "</i>";
            }
        }
    }else if (listar.equals("listarajustes")) {
    // Listar ajustes de inventario
    rs = st.executeQuery("SELECT  to_char(a.fecha, 'dd-mm-yyyy') AS fecha_formateada, u.datos, a.tipo, a.estado, a.id FROM ajusteinventario a JOIN usuarios u ON a.idusuarios = u.id WHERE a.estado ='Finalizado'; ");
    while (rs.next()) {
%>
<tr>
    <td><%= rs.getString(1) %></td> <!-- id del ajuste -->
    <td><%= rs.getString(2) %></td> <!-- fecha del ajuste -->
    <td><%= rs.getString(3) %></td> <!-- nombre del usuario -->
    <td><%= rs.getString(4) %></td> <!-- tipo de ajuste -->
    <td><%= rs.getString(5) %></td> <!-- estado del ajuste -->
    <td>
      <% if (sesion.getAttribute("rol").equals("ADMINISTRADOR")) { %>
      <button class="btn btn-outline-secondary" onclick="$('#pkim').val('<%= rs.getString(1) %>')" title="Imprimir">
            <img src="img/impresora (1).png" title="Imprimir" data-toggle="modal" data-target="#Imprimir">
        </button>
        <button type="button" class="btn btn-outline-danger" style="color:red" data-toggle="modal" data-target="#exampleModal" onclick="$('#idpk').val(<%= rs.getString(1) %>);">
            <img src="img/papelera-de-reciclaje.png"></button>
       <% } %>
    </td>
</tr>
<%
    }
}else if (listar.equals("cancelarajuste")) {
        // Cancelar ajuste
        Statement st = null;

        try {
            st = conn.createStatement();
            st.executeUpdate("UPDATE ajusteinventario SET estado='CANCELADO' WHERE estado='PENDIENTE'");
            mensajeValidacion = "<i class='alert alert-success'>Ajuste cancelado correctamente.</i>";
        } catch (SQLException e) {
            mensajeValidacion = "<i class='alert alert-danger'>Error PSQL: " + e.getMessage() + "</i>";
        } finally {
            try {
                if (st != null) st.close();
            } catch (SQLException e) {
                mensajeValidacion = "<i class='alert alert-danger'>Error cerrando recursos: " + e.getMessage() + "</i>";
            }
        }
    }} else if (listar.equals("anularajuste")) {
    // Anular ajuste
    String ajustePk = request.getParameter("pkd"); // Asegúrate de que estás pasando "pkd" desde el frontend
    Statement st = null;

    try {
        st = conn.createStatement();
        // Asegúrate de que el ID existe en la tabla
        ResultSet rs = st.executeQuery("SELECT id FROM ajusteinventario WHERE id='" + ajustePk + "'");
        if (rs.next()) {
            st.executeUpdate("UPDATE ajusteinventario SET estado='ANULADO' WHERE id='" + ajustePk + "'");
            mensajeValidacion = "<i class='alert alert-success'>Ajuste anulado correctamente.</i>";
        } else {
            mensajeValidacion = "<i class='alert alert-danger'>No se encontró el ajuste con el ID proporcionado.</i>";
        }
    } catch (SQLException e) {
        mensajeValidacion = "<i class='alert alert-danger'>Error PSQL: " + e.getMessage() + "</i>";
    } finally {
        try {
            if (st != null) st.close();
        } catch (SQLException e) {
            mensajeValidacion = "<i class='alert alert-danger'>Error cerrando recursos: " + e.getMessage() + "</i>";
        }
    }
}

%>

<!-- Mostrar el mensaje de validación debajo del formulario -->
<%
if (!mensajeValidacion.isEmpty()) {
    out.println(mensajeValidacion);
}
%>