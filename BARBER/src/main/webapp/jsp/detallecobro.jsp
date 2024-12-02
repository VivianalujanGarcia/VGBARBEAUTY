<%@ include file="conexion.jsp" %>
<%
    if (request.getParameter("listar") != null) {
        String listar = request.getParameter("listar");

        if (listar.equals("listarcobro")) {
            try {
                Statement st = conn.createStatement();
                ResultSet rs = st.executeQuery("SELECT c.numero, c.fecha, cl.nombre, cl.ci, c.id FROM cobros c JOIN clientes cl ON c.idclientes = cl.id_cliente WHERE c.estado='FINALIZADO'");

                // Verificamos si hay resultados
                if (!rs.isBeforeFirst()) {
                    out.println("<tr><td colspan='6'>No se encontraron cobros.</td></tr>");
                } else {
                    while (rs.next()) {
%>
                        <tr>
                            <td style="display:none;"><%= rs.getString(5) %></td>
                            <td><%= rs.getString(1) %></td>
                            <td><%= rs.getString(2) %></td>
                            <td><%= rs.getString(3) %></td>
                            <td><%= rs.getString(4) %></td>
                            <td>
                                <button class="btn btn-outline-secondary" onclick="prepararImpresion('<%= rs.getString(5) %>')" title="Imprimir">
                                    <img src="img/impresora (1).png" title="Imprimir" data-toggle="modal" data-target="#Imprimir"> 
                                </button>
                                <button class="btn btn-outline-danger" onclick="$('#idpk').val('<%= rs.getString(5) %>')" title="Anular" data-toggle="modal" data-target="#exampleModal">
                                     <img src="img/papelera-de-reciclaje.png"></button>
                                </button>
                            </td>
                        </tr>
<%
                    }
                }
            } catch (Exception e) {
                out.println("Error PSQL: " + e.getMessage());
            }
        } else if (listar.equals("anular")) {
            try {
                Statement st = conn.createStatement();
                st.executeUpdate("UPDATE cobros SET estado='ANULADO' WHERE id='" + request.getParameter("pkd") + "'");
                st.executeUpdate("UPDATE cuentaclientes SET estado='PENDIENTE' WHERE id IN (SELECT idcuentaclientes FROM detallecobros WHERE idcobros='" + request.getParameter("pkd") + "')");
            } catch (Exception e) {
                out.println("Error PSQL: " + e.getMessage());
            }
        }
    }
%>
