<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ include file="conexion.jsp" %>
<%
if (request.getParameter("listar") != null && request.getParameter("listar").equals("listar")) {
    try {
        Statement st = conn.createStatement();
        // Primera consulta: Verificar si hay una caja abierta
        ResultSet pk = st.executeQuery("SELECT idmovimiento FROM movimiento_caja WHERE estado='ABIERTA'");
        
        if (pk.next()) {
            // Convertir explícitamente a integer
            int idMovimiento = pk.getInt("idmovimiento");
            
            // Usar PreparedStatement para manejar correctamente los tipos
            String query = "SELECT dt.iddetallemovimientocaja, COALESCE(ventas.ven_numero, '') AS ven_numero, COALESCE(compras.numero, '') AS numero, COALESCE(cobros.numero, '') AS numerocobro,COALESCE(pagos.numero, '') AS numeropago, dt.monto, dt.estado FROM detallemovimientocaja dt LEFT JOIN ventas ON dt.idventas = ventas.id LEFT JOIN cobros ON dt.idcobros = cobros.id LEFT JOIN pagos ON dt.idpagos = pagos.id LEFT JOIN compras ON dt.idcompras = compras.id WHERE dt.idmovimiento = ? ORDER BY dt.iddetallemovimientocaja ASC;";
                         
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1, idMovimiento);  // Establecer el parámetro como integer
            
            ResultSet rs = ps.executeQuery();
            boolean hasData = false;
            
            while (rs.next()) {
                hasData = true;
                // Obtenemos los valores
                String idVentas = rs.getString("ven_numero");
                String idCompras = rs.getString("numero");
                String idcobros = rs.getString("numerocobro");
                String idpagos = rs.getString("numeropago");
                String monto = rs.getString("monto");
                String estado = rs.getString("estado");
                
                // Validar cada campo
                idVentas = (idVentas != null && !idVentas.trim().isEmpty()) ? idVentas : "-";
                idCompras = (idCompras != null && !idCompras.trim().isEmpty()) ? idCompras : "-";
                idcobros = (idcobros != null && !idcobros.trim().isEmpty()) ? idcobros : "-";
                idpagos = (idpagos != null && !idpagos.trim().isEmpty()) ? idpagos : "-";
                monto = (monto != null && !monto.trim().isEmpty()) ? monto : "0";
%>
<tr>
    <td><%= idVentas %></td>
    <td><%= idCompras %></td>
    <td><%= idcobros %></td>
    <td><%= idpagos %></td>
    <td><%= monto %></td>
    <td><%= estado %></td>
</tr>
<%
            }
            
            if (!hasData) {
                out.println("<tr><td colspan='5' style='text-align: center; color: red;'>No hay movimiento de la caja actual</td></tr>");
            }
            
            rs.close();
            ps.close();
        } else {
            out.println("<tr><td colspan='4' style='text-align: center; color: red;'>No hay caja abierta</td></tr>");
        }
        pk.close();
        st.close();
        
    } catch (Exception e) {
        System.out.println("Error en la consulta: " + e.getMessage()); // Debug log
        e.printStackTrace(); // Imprime el stack trace completo
        out.println("<tr><td colspan='3' style='text-align: center; color: red;'>Error en la consulta: " + e.getMessage() + "</td></tr>");
    }
}else if (request.getParameter("listar").equals("mostrartotales")) {
    try {
        Statement st = null;
        ResultSet rs = null;
        ResultSet pk = null;
        int sumador = 0;
        st = conn.createStatement();
        
        // Obtener el idventas de estado 'PENDIENTE'
        pk = st.executeQuery("SELECT id FROM ventas WHERE estado='PENDIENTE'");
        if (pk.next()) {
            String idVentas = pk.getString(1);
            
            // Realizar el cálculo en la consulta SQL
            rs = st.executeQuery("SELECT "
                + "CAST(dt.precio AS numeric) * CAST(dt.cantidad AS numeric) AS subtotal, "
                + "CASE WHEN p.prop_iva = 5 THEN CAST(CAST(dt.precio AS numeric) * CAST(dt.cantidad AS numeric) * 0.70 AS integer) ELSE 0 END AS exenta, "
                + "CASE WHEN p.prop_iva = 5 THEN CAST(CAST(dt.precio AS numeric) * CAST(dt.cantidad AS numeric) * 0.30 + (CAST(dt.precio AS numeric) * CAST(dt.cantidad AS numeric) * 0.30 * 0.05) AS integer) ELSE 0 END AS cinco, "
                + "CASE WHEN p.prop_iva = 10 THEN CAST(CAST(dt.precio AS numeric) * CAST(dt.cantidad AS numeric) * 0.10 AS integer) ELSE 0 END AS diez, "
                + "CASE WHEN p.prop_iva = 5 THEN CAST(CAST(dt.precio AS numeric) * CAST(dt.cantidad AS numeric) * 0.30 * 0.05 AS integer) ELSE 0 END AS liqiva5, "
                + "CASE WHEN p.prop_iva = 5 THEN COALESCE(CAST(CAST(dt.precio AS numeric) * CAST(dt.cantidad AS numeric) * 0.70 AS integer), 0) + COALESCE(CAST(CAST(dt.precio AS numeric) * CAST(dt.cantidad AS numeric) * 0.30 + (CAST(dt.precio AS numeric) * CAST(dt.cantidad AS numeric) * 0.30 * 0.05) AS integer), 0) ELSE 0 END AS TOTAL "
                + "FROM detalleventas dt "
                + "JOIN propiedades p ON dt.idpropiedades = p.idpropiedades "
                + "WHERE dt.idventas='" + idVentas + "'");
            
            while (rs.next()) {
                int total = rs.getInt("TOTAL");
                sumador += total;
            }
            out.println(sumador);
        }
    } catch (Exception e) {
        out.println("error PSQL: " + e.getMessage());
    }
}
%>