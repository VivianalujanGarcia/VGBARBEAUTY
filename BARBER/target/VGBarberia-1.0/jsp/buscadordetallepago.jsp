<%@ include file="conexion.jsp" %>
<%
    String listar = request.getParameter("listar");

    if (listar != null) {
        if (listar.equals("buscaralumno")) {
            PreparedStatement ps = null;
            ResultSet rs = null;
            try {
                String query = "SELECT DISTINCT c.id_proveedor, c.nombre, c.ruc FROM proveedores c JOIN compras v ON c.id_proveedor = v.id_proveedor JOIN cuentasproveedores cc ON v.id = cc.idcompras WHERE cc.estado = 'PENDIENTE'";
                ps = conn.prepareStatement(query);
                rs = ps.executeQuery();
%>
                <option value="">Seleccione un Proveedor:</option>
<%
                while (rs.next()) {
%>
                <option value="<%= rs.getString(1) %>,<%= rs.getString(3) %>" data-nombre=""><%= rs.getString(2) %></option>
<%
                }
            } catch (Exception e) {
                out.println("Error PSQL: " + e.getMessage());
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException e) { /* Handle error */ }
                if (ps != null) try { ps.close(); } catch (SQLException e) { /* Handle error */ }
            }
        } else if (listar.equals("cargarcuentapendiente")) {
            String proveedorId = request.getParameter("proveedorId");
            if (proveedorId != null) {
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    String query = "SELECT cc.id, cc.cuota, cc.vencimiento, cc.monto, cc.nrocuota FROM cuentasproveedores cc INNER JOIN compras v ON cc.idcompras = v.id WHERE v.id_proveedor =? AND cc.estado = 'PENDIENTE'";
                    ps = conn.prepareStatement(query);
                    ps.setInt(1, Integer.parseInt(proveedorId));
                    rs = ps.executeQuery();

                    while (rs.next()) {
%>
<tr>
    <td><%= rs.getString("id") %></td>
    <td><%= rs.getString("vencimiento") %></td>
    <td><%= rs.getString("monto") %></td>
    <td><%= rs.getString("nrocuota") %></td>
    <td>
        <div class="form-group">
            <div class="form-check" align="center">
                <input class="form-check-input cuentas" data-monto="<%= rs.getString("monto") %>" type="checkbox" id="checkbox_<%= rs.getString("id") %>" name="idcuentaproveedores" value="<%= rs.getString("id") %>"/>
            </div>
        </div>
    </td>
</tr>
<%
                    }
                } catch (Exception e) {
                    out.println("Error PSQL: " + e.getMessage());
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) { /* Handle error */ }
                    if (ps != null) try { ps.close(); } catch (SQLException e) { /* Handle error */ }
                }
            }
        // Recuperar el monto total de las cuentas pendientes de un cliente
        } else if (listar.equals("montoTotalCuentas")) {
            String clienteId = request.getParameter("clienteId");
            if (clienteId != null) {
                PreparedStatement ps = null;
                ResultSet rs = null;
                double montoTotal = 0.0;

                try {
                    // Consulta para obtener el monto total de las cuentas pendientes
                    String query = "SELECT SUM(cc.monto) AS totalMonto FROM cuentasclientes cc INNER JOIN ventas v ON cc.idventas = v.id WHERE v.id_cliente = ? AND cc.estado = 'PENDIENTE'";
                    ps = conn.prepareStatement(query);
                    ps.setInt(1, Integer.parseInt(clienteId));
                    rs = ps.executeQuery();

                    if (rs.next()) {
                        montoTotal = rs.getDouble("totalMonto"); // Recupera el monto total
                    }

                    // Enviar el monto total como respuesta
                    out.println(montoTotal);
                } catch (Exception e) {
                    out.println("Error PSQL: " + e.getMessage());
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) { /* Handle error */ }
                    if (ps != null) try { ps.close(); } catch (SQLException e) { /* Handle error */ }
                }
            }
        } else if (listar.equals("finalizar")) {
            String idproveedores = request.getParameter("id_proveedor");
            String idabrircaja = request.getParameter("idabrircaja");
            String fechaFormateada = request.getParameter("fecharegistro");
            String fechas[] = fechaFormateada.split("-");
            fechaFormateada = fechas[2] + "-" + fechas[1] + "-" + fechas[0];
            String numero = request.getParameter("numero");
            String[] idcuentaproveedoresSeleccionados = request.getParameterValues("idcuentaproveedores[]");

            // Mensajes de depuración
            out.println("ID Proveedor: " + idproveedores);
            out.println("ID Abrir Caja: " + idabrircaja);
            out.println("Fecha: " + fechaFormateada);
            out.println("Numero: " + numero);
            out.println("Cuentas seleccionadas: " + (idcuentaproveedoresSeleccionados != null ? idcuentaproveedoresSeleccionados.length : 0));

            if (idcuentaproveedoresSeleccionados != null && idcuentaproveedoresSeleccionados.length > 0) {
                PreparedStatement psInsert = null;
                PreparedStatement psUpdate = null;

                try {
                    conn.setAutoCommit(false); // Desactiva auto-commit

                    // Inserta el cobro
                    String insertPago = "INSERT INTO pagos(idproveedores, idabrircaja, fecha, numero, estado) VALUES(?, ?, ?, ?, 'FINALIZADO')";
                    psInsert = conn.prepareStatement(insertPago, Statement.RETURN_GENERATED_KEYS);
                    psInsert.setInt(1, Integer.parseInt(idproveedores));
                    psInsert.setInt(2, Integer.parseInt(idabrircaja));
                    psInsert.setDate(3, java.sql.Date.valueOf(fechaFormateada));
                    psInsert.setInt(4, Integer.parseInt(numero));

                    int affectedRows = psInsert.executeUpdate(); // Ejecutar la inserción

                    // Verifica si la inserción fue exitosa
                    if (affectedRows == 0) {
                        throw new SQLException("No se pudo insertar el pago.");
                    }

                    // Obtiene el ID del nuevo cobro
                    ResultSet generatedKeys = psInsert.getGeneratedKeys();
                    String idpagos = null;
                    if (generatedKeys.next()) {
                        idpagos = generatedKeys.getString(1);
                    } else {
                        throw new SQLException("No se obtuvo el ID del nuevo pago.");
                    }

                    // Inserta los detalles del cobro y actualiza el estado
                    for (String id : idcuentaproveedoresSeleccionados) {
                        // Inserción en detallepagos
                        psInsert = conn.prepareStatement("INSERT INTO detallepagos(idpagos, idcuentaproveedores) VALUES(?, ?)");
                        psInsert.setInt(1, Integer.parseInt(idpagos));
                        psInsert.setInt(2, Integer.parseInt(id)); // Usa el ID de la cuenta
                        psInsert.executeUpdate();

                        // Actualiza el estado de la cuenta
                        psUpdate = conn.prepareStatement("UPDATE cuentasproveedores SET estado = 'PAGADO' WHERE id = ?");
                        psUpdate.setInt(1, Integer.parseInt(id));
                        psUpdate.executeUpdate();
                    }

                    conn.commit(); // Realiza el commit
                    out.println("Pago y detalles insertados correctamente.");
                } catch (SQLException e) {
                    if (conn != null) {
                        try {
                            conn.rollback(); // Deshace la transacción en caso de error
                        } catch (SQLException ex) {
                            out.println("Error al hacer rollback: " + ex.getMessage());
                        }
                    }
                    out.println("Error PSQL al finalizar: " + e.getMessage());
                } finally {
                    if (psInsert != null) try { psInsert.close(); } catch (SQLException e) { /* Handle error */ }
                    if (psUpdate != null) try { psUpdate.close(); } catch (SQLException e) { /* Handle error */ }
                    if (conn != null) try { conn.setAutoCommit(true); } catch (SQLException e) { /* Handle error */ }
                }
            } else {
                out.println("No se seleccionaron cuentas para procesar.");
            }
        } else if (listar.equals("listarpago")) {
            PreparedStatement ps = null;
            ResultSet rs = null;
            try {
                String query = "SELECT c.id, c.fecha, cl.nombre, cl.ruc ,c.estado FROM pagos c JOIN proveedores cl ON c.idproveedores = cl.id_proveedor where estado='FINALIZADO'";
                ps = conn.prepareStatement(query);
                rs = ps.executeQuery();
                while (rs.next()) {
%>
                <tr>
                    <td style="display:none;"><%= rs.getString("id") %></td>
                    <td><%= rs.getRow() %></td>
                    <td><%= rs.getString("fecha") %></td>
                    <td><%= rs.getString("nombre") %></td>
                    <td><%= rs.getString("ruc") %></td>
                    <td><%= rs.getString("estado") %></td>
                <td>
                    <button type="button" class="btn btn-outline-danger" style="color:red" data-toggle="modal" data-target="#exampleModal" onclick="anularPago('<%= rs.getString("id") %>')"> 
                    <img src="img/papelera-de-reciclaje.png"></button>
                    <button class="btn btn-outline-secondary" onclick="$('#pkim').val('<%= rs.getString(1) %>')" title="Imprimir"> 
                        <img src="img/impresora (1).png" title="Imprimir" data-toggle="modal" data-target="#Imprimir"> 
                    </button>
               </td>
                </tr>
<%
                }
            } catch (SQLException e) {
                out.println("Error PSQL: " + e.getMessage());
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException e) { /* Handle error */ }
                if (ps != null) try { ps.close(); } catch (SQLException e) { /* Handle error */ }
            }
        } else if (listar.equals("anular")) {
            String pkd = request.getParameter("pkd");
            if (pkd != null) {
                try {
                    PreparedStatement ps = conn.prepareStatement("UPDATE pagos SET estado = 'ANULADO' WHERE id = ?");
                    ps.setInt(1, Integer.parseInt(pkd));
                    ps.executeUpdate();
                    out.println("Cobro anulado correctamente.");
                } catch (SQLException e) {
                    out.println("Error al anular el cobro: " + e.getMessage());
                }
            }
        }
    }
%>
