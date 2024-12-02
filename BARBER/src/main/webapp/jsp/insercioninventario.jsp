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
                rs = st.executeQuery("SELECT cantidad FROM productos WHERE id_producto = '" + codproducto + "'");

                if (rs.next()) {
                    int stockDisponible = rs.getInt("cantidad");
                    int cantidadAjuste = Integer.parseInt(cant_ajuste);

                    // Si el tipo de ajuste es "descuento", verifica si hay suficiente stock
                    if ("descuento".equals(tipo.toLowerCase())) {
                        if (cantidadAjuste > stockDisponible) {
                            mensajeValidacion = "<i class='alert alert-danger'>Error: No hay suficiente cantidad disponible. Stock disponible: " + stockDisponible + ".</i>";
                        } else {
                            // Realizar el ajuste si hay suficiente stock
                            rs = st.executeQuery("SELECT id FROM ajusteinventario WHERE estado='PENDIENTE'");

                            if (rs.next()) {
                                // Sumar o restar la cantidad según el tipo
                                cantidadAjuste = -cantidadAjuste; // Para descuento, hacemos negativo el ajuste

                                st.executeUpdate("INSERT INTO detalleajuste(idajusteinve, idproductos, motivo, cant_ajuste) " +
                                                 "VALUES('" + rs.getString(1) + "','" + codproducto + "','" + motivo + "','" + cantidadAjuste + "')");
                                mensajeValidacion = "<i class='alert alert-success'>Detalle cargado.</i>";
                            } else {
                                st.executeUpdate("INSERT INTO ajusteinventario(fecha, tipo, idusuarios, estado) " +
                                                 "VALUES('" + fecharegistro + "','" + tipo + "', " + idusuario + ", 'PENDIENTE')");
                                pk = st.executeQuery("SELECT id FROM ajusteinventario WHERE estado='PENDIENTE'");
                                if (pk.next()) {
                                    cantidadAjuste = -cantidadAjuste; // Para descuento, hacemos negativo el ajuste

                                    st.executeUpdate("INSERT INTO detalleajuste(idajusteinve, idproductos, motivo, cant_ajuste) " +
                                                     "VALUES('" + pk.getString(1) + "','" + codproducto + "','" + motivo + "','" + cantidadAjuste + "')");
                                    mensajeValidacion = "<i class='alert alert-success'>Ajuste cargado.</i>";
                                } else {
                                    mensajeValidacion = "<i class='alert alert-danger'>No se pudo crear el ajuste pendiente.</i>";
                                }
                            }
                        }
                    } else if ("aumento".equals(tipo.toLowerCase())) {
                        // Si el tipo es aumento, sumamos la cantidad
                        // Primero, no necesitamos validar el stock, ya que no importa si tenemos suficiente, siempre sumamos

                        rs = st.executeQuery("SELECT id FROM ajusteinventario WHERE estado='PENDIENTE'");

                        if (rs.next()) {
                            // Para aumento, simplemente sumamos la cantidad al ajuste
                            st.executeUpdate("INSERT INTO detalleajuste(idajusteinve, idproductos, motivo, cant_ajuste) " +
                                             "VALUES('" + rs.getString(1) + "','" + codproducto + "','" + motivo + "','" + cantidadAjuste + "')");

                            // Actualizamos la cantidad del producto al sumar el ajuste
                            st.executeUpdate("UPDATE productos SET cantidad = cantidad + " + cantidadAjuste + " WHERE id_producto = '" + codproducto + "'");

                            mensajeValidacion = "<i class='alert alert-success'>Detalle cargado y cantidad actualizada.</i>";
                        } else {
                            st.executeUpdate("INSERT INTO ajusteinventario(fecha, tipo, idusuarios, estado) " +
                                             "VALUES('" + fecharegistro + "','" + tipo + "', " + idusuario + ", 'PENDIENTE')");
                            pk = st.executeQuery("SELECT id FROM ajusteinventario WHERE estado='PENDIENTE'");
                            if (pk.next()) {
                                st.executeUpdate("INSERT INTO detalleajuste(idajusteinve, idproductos, motivo, cant_ajuste) " +
                                                 "VALUES('" + pk.getString(1) + "','" + codproducto + "','" + motivo + "','" + cantidadAjuste + "')");

                                // Actualizamos la cantidad del producto al sumar el ajuste
                                st.executeUpdate("UPDATE productos SET cantidad = cantidad + " + cantidadAjuste + " WHERE id_producto = '" + codproducto + "'");

                                mensajeValidacion = "<i class='alert alert-success'>Ajuste cargado y cantidad actualizada.</i>";
                            } else {
                                mensajeValidacion = "<i class='alert alert-danger'>No se pudo crear el ajuste pendiente.</i>";
                            }
                        }
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
                                    <img src="img/papelera-de-reciclaje.png">
                                </button>
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
        Statement st = null; 
        ResultSet pkResultSet = null;

        try {
            st = conn.createStatement();
            pkResultSet = st.executeQuery("SELECT id FROM ajusteinventario WHERE estado='PENDIENTE' LIMIT 1");

            if (pkResultSet.next()) {
                int idAjuste = pkResultSet.getInt(1);
                int rowsUpdated = st.executeUpdate("UPDATE ajusteinventario SET estado='FINALIZADO' WHERE id=" + idAjuste);

                if (rowsUpdated > 0) {
                    mensajeValidacion = "<i class='alert alert-success'>Ajuste finalizado correctamente.</i>";
                } else {
                    mensajeValidacion = "<i class='alert alert-warning'>No se pudo actualizar el ajuste.</i>";
                }
            } else {
                mensajeValidacion = "<i class='alert alert-warning'>No hay ajustes pendientes para finalizar.</i>";
            }
        } catch (SQLException e) {
            mensajeValidacion = "<i class='alert alert-danger'>Error PSQL: " + e.getMessage() + "</i>";
        } finally {
            try {
                if (pkResultSet != null) pkResultSet.close();
                if (st != null) st.close();
            } catch (SQLException e) {
                mensajeValidacion = "<i class='alert alert-danger'>Error cerrando recursos: " + e.getMessage() + "</i>";
            }
        }

    } else if (listar.equals("listarajuste")) {
        // Listar ajustes finalizados
        Statement st = null; 
        ResultSet rs = null;
        st = conn.createStatement();
        rs = st.executeQuery("SELECT to_char(a.fecha, 'dd-mm-yyyy') AS fecha_formateada, u.datos, a.tipo, a.estado, a.id " +
                             "FROM ajusteinventario a JOIN usuarios u ON a.idusuarios = u.id WHERE a.estado ='FINALIZADO';");
        while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getString(5) %></td>
                <td><%= rs.getString(1) %></td>
                <td><%= rs.getString(2) %></td>
                <td><%= rs.getString(3) %></td>
                <td><%= rs.getString(4) %></td>
                <td>
                    <% if (sesion.getAttribute("rol").equals("ADMINISTRADOR")) { %>
                        <button type="button" class="btn btn-outline-danger" style="color:red" data-toggle="modal" data-target="#exampleModal" onclick="$('#idpk').val(<%= rs.getString(5) %>);">
                            <img src="img/papelera-de-reciclaje.png"></button>
                    <% } %>
                </td>
            </tr>
            <%
        }
    } else if (listar.equals("anularajuste")) {
        // Anular ajuste y restaurar productos al inventario
        String pkd = request.getParameter("pkd");
        if (pkd != null) {
            ResultSet rs = null;
            Statement st = conn.createStatement();
            try {
                rs = st.executeQuery("SELECT dt.idproductos, dt.cant_ajuste FROM detalleajuste dt WHERE dt.idajusteinve='" + pkd + "'");

                while (rs.next()) {
                    String idProducto = rs.getString("idproductos");
                    int cantidadAjustada = rs.getInt("cant_ajuste");

                    // Restaurar la cantidad de los productos en el inventario
                    st.executeUpdate("UPDATE productos SET cantidad = cantidad - " + cantidadAjustada + " WHERE id_producto = '" + idProducto + "'");
                }

                // Cambiar el estado del ajuste a 'ANULADO'
                st.executeUpdate("UPDATE ajusteinventario SET estado='ANULADO' WHERE id='" + pkd + "'");

                mensajeValidacion = "<i class='alert alert-success'>Ajuste anulado y cantidades restauradas al inventario.</i>";

            } catch (SQLException e) {
                mensajeValidacion = "<i class='alert alert-danger'>Error al anular el ajuste: " + e.getMessage() + "</i>";
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (st != null) st.close();
                } catch (SQLException e) {
                    mensajeValidacion += "<i class='alert alert-danger'> Error al cerrar recursos: " + e.getMessage() + "</i>";
                }
            }
        } else {
            mensajeValidacion = "<i class='alert alert-danger'>Error: ID de ajuste no especificado.</i>";
        }
    }
%>

<!-- Mostrar el mensaje de validación debajo del formulario -->
<%
    if (!mensajeValidacion.isEmpty()) {
        out.println(mensajeValidacion);
    }
%>
