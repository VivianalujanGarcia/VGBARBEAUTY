<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ include file="conexion.jsp" %>
<%
if (request.getParameter("listar") != null && request.getParameter("listar").equals("listar")) {
    try {
        Statement st = conn.createStatement();
        // Primera consulta: Verificar si hay una caja abierta
        ResultSet rs = st.executeQuery("WITH compras_ventas AS (SELECT id, fecha, id_proveedor as cliente_proveedor, total as total_transaccion, 'Compra' as tipo_transaccion, numero, total AS egreso, 0 AS ingreso FROM compras WHERE estado='Finalizado' AND condicion='contado' 	UNION ALL  SELECT id, fecha, id_cliente as cliente_proveedor, total as total_transaccion, 'Venta' as tipo_transaccion, numero, 0 AS egreso, total as ingreso from ventas WHERE estado='Finalizado' AND condicion='contado'   UNION ALL   SELECT p.id, cc.fecha as fecha, cc.id_proveedor as cliente_proveedor, p.monto as total_transaccion, 'Pago' as tipo_transaccion, p.nrocuota as numero, p.monto AS egreso, 0 AS ingreso from cuentasproveedores p INNER JOIN compras cc on p.idcompras=cc.id  UNION ALL   SELECT c.id, v.fecha as fecha, v.id_cliente as cliente_proveedor, c.monto as total_transaccion, 'Cobro' as tipo_transaccion, c.nrocuota as numero, 0 AS egreso, c.monto as ingreso from cuentasclientes c INNER JOIN ventas v on c.idventas=v.id  )  SELECT id, fecha, tipo_transaccion,ingreso, egreso, (SELECT SUM(ingreso) FROM compras_ventas) as total_ingreso, (SELECT SUM(egreso) FROM compras_ventas) as total_egreso from compras_ventas;");
            String total_ingreso = "";
            String total_egreso = "";
            while (rs.next()) {
            total_ingreso = rs.getString("total_ingreso");
            total_egreso = rs.getString("total_egreso");

%>
<tr>
    <td><%=  rs.getString("fecha") %></td>
    <td><%= rs.getString("tipo_transaccion") %></td>
    <td><%= rs.getString("ingreso") %></td>
    <td><%= rs.getString("egreso") %></td>
</tr>
<%
    }
%>
<script>
    $("#totalingreso").html("<%=  total_ingreso %>");
    $("#totalegreso").html("<%=  total_egreso %>");
    let res = <%=  total_ingreso %> - <%=  total_egreso %>
    $("#diferencia").html(res);
</script>
<%
    } catch (Exception e) {
        System.out.println("Error en la consulta: " + e.getMessage()); // Debug log
        e.printStackTrace(); // Imprime el stack trace completo
        out.println("<tr><td colspan='3' style='text-align: center; color: red;'>Error en la consulta: " + e.getMessage() + "</td></tr>");
    }
}
%>