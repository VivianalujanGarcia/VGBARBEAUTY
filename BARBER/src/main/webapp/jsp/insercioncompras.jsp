<%@ include file="conexion.jsp" %>
<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>

<%
HttpSession sesion = request.getSession();
%>

<%
String listar = request.getParameter("listar");
Statement st = null;
ResultSet rs = null;
ResultSet pkResultSet = null;

try {
    st = conn.createStatement();

    if (listar.equals("cargar")) {
        // Obtener datos para la cabecera
        String codalumno = request.getParameter("codalumno");
        String fecharegistro = request.getParameter("fecharegistro");
        String codproducto = request.getParameter("codproducto");
        String precioStr = request.getParameter("precio");
        String cantidadStr = request.getParameter("cantidad");
        String condicion = request.getParameter("condicion");
        String numero = request.getParameter("numero");

        // Validar que los parámetros no sean nulos o vacíos
        if (codalumno == null || codalumno.isEmpty() || fecharegistro == null || fecharegistro.isEmpty() || codproducto == null || codproducto.isEmpty()) {
            out.println("<i class='alert alert-danger'>Error: Todos los campos son obligatorios.</i>");
            return;
        }

        // Verificar y convertir precio y cantidad a enteros
        int precio = 0;
        int cantidad = 0;
        try {
            precio = Integer.parseInt(precioStr);
            cantidad = Integer.parseInt(cantidadStr);
            if (precio <= 0 || cantidad <= 0) {
                out.println("Error: El precio y la cantidad deben ser mayores a 0.");
                return;
            }
        } catch (NumberFormatException e) {
            out.println("Error: El precio o la cantidad no es un número válido.");
            return;
        }

        // Buscar compra pendiente
        rs = st.executeQuery("SELECT id FROM compras WHERE estado='pendiente'");
        if (rs.next()) {
            // Si hay cabecera, insertar detalle
            st.executeUpdate("INSERT INTO detallecompras(idcompra, cantidad, precio, id_producto) VALUES (" + rs.getString(1) + ", " + cantidad + ", " + precio + ", '" + codproducto + "')");
            out.println("<i class='alert alert-success'>Detalle cargado</i>");
        } else {
            // Insertar cabecera y luego detalle
            st.executeUpdate("INSERT INTO compras(id_proveedor, fecha, estado, numero, condicion) VALUES ('" + codalumno + "', '" + fecharegistro + "', 'pendiente', " + numero + ", '" + condicion + "')");
            pkResultSet = st.executeQuery("SELECT id FROM compras WHERE estado='pendiente'");
            if (pkResultSet.next()) {
                st.executeUpdate("INSERT INTO detallecompras(idcompra, cantidad, precio, id_producto) VALUES (" + pkResultSet.getString(1) + ", " + cantidad + ", " + precio + ", '" + codproducto + "')");
                out.println("<i class='alert alert-success'>Datos cargados</i>");
            } else {
                out.println("No se encontró la compra pendiente para insertar el detalle.");
            }
        }

    } else if (listar.equals("listar")) {
        int sumador = 0;
        int ivaTotal = 0; // Inicializamos ivaTotal
        // Listar detalles de compra
        pkResultSet = st.executeQuery("SELECT id FROM compras WHERE estado='pendiente'");
        if (pkResultSet.next()) {
            rs = st.executeQuery("SELECT dt.id, p.descripcion, dt.precio, dt.cantidad, p.iva FROM detallecompras dt, productos p WHERE dt.id_producto = p.id_producto AND dt.idcompra='" + pkResultSet.getString(1) + "';");
            while (rs.next()) {
                String precio = rs.getString(3);
                String cantidad = rs.getString(4);
                String iva = rs.getString(5);
                Integer precioI = Integer.parseInt(precio);
                Integer cantidadI = Integer.parseInt(cantidad);
                int calculo = precioI * cantidadI;
                sumador += calculo;

                // Calcular el IVA basado en el valor guardado
                int porcentajeIva = Integer.parseInt(iva); // Asumiendo que el valor de IVA es el porcentaje
                int calculoIva = (calculo * porcentajeIva) / 100;

                // Acumular el IVA total
                ivaTotal += calculoIva;
%>
<tr>
    <td>
        <button type="button" class="btn btn-outline-danger" style="color:red" data-toggle="modal" data-target="#exampleModal" onclick="$('#idpk').val(<%= rs.getString(1) %>);"> 
            <img src="img/papelera-de-reciclaje.png"></button>
    </td>
    <td><%= rs.getString(2) %></td>
    <td><%= rs.getString(3) %></td>
    <td><%= rs.getString(4) %></td>
    <td><%= calculoIva %> (IVA <%= porcentajeIva %>%)</td> <!-- IVA -->
    <td><%= calculo %></td> <!-- Subtotal sin IVA -->
    <td><%= calculo + calculoIva %></td> <!-- Total con IVA (Subtotal + IVA) -->
</tr>
<%
            }
%>
<input type="hidden" id="qrtotal" value="<%= (sumador + ivaTotal) %>">
<%
            out.println("<tr><td colspan='5'><td>SubTotal IVA: " + sumador + "</td><td>Total General (con IVA): " + (sumador + ivaTotal) + "</td></tr>");
        } else {
            // out.println("No se encontraron compras pendientes.");
        }

    } else if (listar.equals("eliminardetalle")) {
        // Eliminar detalle de compra
        String detallePk = request.getParameter("pk");
        if (detallePk != null && !detallePk.isEmpty()) {
            st.executeUpdate("DELETE FROM detallecompras WHERE id='" + detallePk + "'");
            out.println("<i class='alert alert-success'>Datos eliminados</i>");
        } else {
            out.println("Error: El identificador del detalle es obligatorio.");
        }

    } else if (listar.equals("cancelarcompra")) {
        // Cancelar compra
        pkResultSet = st.executeQuery("SELECT id FROM compras WHERE estado='pendiente'");
        if (pkResultSet.next()) {
            st.executeUpdate("UPDATE compras SET estado='Cancelado' WHERE id='" + pkResultSet.getString(1) + "'");
            out.println("<i class='alert alert-success'>Compra cancelada</i>");
        } else {
            out.println("No se encontró la compra pendiente para cancelar.");
        }

    } else if (listar.equals("finalizarcompra")) {
        // Finalizar compra
        pkResultSet = st.executeQuery("SELECT id, fecha, condicion FROM compras WHERE estado='pendiente'");
        if (pkResultSet.next()) {
            int idCompra = pkResultSet.getInt("id");
            String fechaCompra = pkResultSet.getString("fecha");
            String condicion = pkResultSet.getString("condicion");

            // Calcular el total de la compra finalizada con IVA
            rs = st.executeQuery("SELECT SUM(dt.precio * dt.cantidad * (1 + (p.iva / 100.0))) FROM detallecompras dt JOIN productos p ON dt.id_producto = p.id_producto WHERE dt.idcompra='" + idCompra + "'");
            if (rs.next()) {
                double totalConIva = rs.getDouble(1);
                st.executeUpdate("UPDATE compras SET estado='Finalizado', total=" + totalConIva + " WHERE id='" + idCompra + "'");
                out.println("<i class='alert alert-success'>Compra finalizada. Total con IVA: " + totalConIva + "</i>");

                // Si la condición es crédito, crear una cuenta proveedor
                if ("credito".equalsIgnoreCase(condicion)) {
                    // Calcular la fecha de vencimiento (30 días después de la fecha de compra)
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    Date fecha = sdf.parse(fechaCompra);
                    Calendar calendar = Calendar.getInstance();
                    calendar.setTime(fecha);
                    calendar.add(Calendar.DAY_OF_MONTH, 30);
                    String fechaVencimiento = sdf.format(calendar.getTime());

                    // Insertar un nuevo registro en la tabla cuentasproveedores
                    String sqlInsertCuentaProveedor = "INSERT INTO cuentasproveedores (monto, cuota, nrocuota, vencimiento, estado, idcompras) " +
                                                      "VALUES (" + totalConIva + ", 1, 1, '" + fechaVencimiento + "', 'PENDIENTE', " + idCompra + ")";
                    st.executeUpdate(sqlInsertCuentaProveedor);
                }

                // Listar proveedores asociados a la compra finalizada
                rs = st.executeQuery("SELECT p.nombre, p.ruc FROM compras c JOIN proveedores p ON c.id_proveedor = p.id_proveedor WHERE c.id='" + idCompra + "'");
                while (rs.next()) {
%>
<tr>
    <td><%= rs.getString("nombre") %></td>
    <td><%= rs.getString("ruc") %></td>
</tr>
<%
                }
            } else {
                out.println("Error al calcular el total de la compra.");
            }
        } else {
            out.println("No se encontró la compra pendiente para finalizar.");
        }

    } else if (listar.equals("listarcompra")) {
        // Listar compras finalizadas
        rs = st.executeQuery("SELECT to_char(v.fecha, 'dd-mm-yyyy') AS fecha_formateada, a.nombre, a.ruc, v.total, v.condicion,v.id FROM compras v JOIN proveedores a ON v.id_proveedor = a.id_proveedor WHERE v.estado ='Finalizado';");
        while (rs.next()) {
%>
<tr>
    <td><%= rs.getString(6) %></td>
    <td><%= rs.getString(1) %></td>
    <td><%= rs.getString(2) + ' ' + rs.getString(3) %></td>
    <td><%= rs.getString(4) %></td>
    <td><%= rs.getString(5) %></td>
    <td>
         <button class="btn btn-outline-secondary" onclick="$('#pkim').val('<%= rs.getString(6) %>')" title="Imprimir"> 
            <img src="img/impresora (1).png" title="Imprimir" data-toggle="modal" data-target="#Imprimir"> 
        </button>
        <button type="button" class="btn btn-outline-danger" style="color:red" data-toggle="modal" data-target="#exampleModal" onclick="$('#idpk').val(<%= rs.getString(6) %>);"> 
            <img src="img/papelera-de-reciclaje.png"></button>
    </td>
</tr>
<%
        }

    } else if (listar.equals("anularcompra")) {
        // Anular compra
        String pkd = request.getParameter("pkd");
        if (pkd != null && !pkd.isEmpty()) {
            st.executeUpdate("UPDATE compras SET estado='Anulado' WHERE id='" + pkd + "'");
            out.println("<i class='alert alert-success'>Compra anulada</i>");
        } else {
            out.println("Error: El identificador de la compra es obligatorio.");
        }
    }

} catch (SQLException e) {
    out.println("Error al ejecutar consulta SQL: " + e.getMessage());
} finally {
    try {
        if (rs != null) rs.close();
        if (pkResultSet != null) pkResultSet.close();
        if (st != null) st.close();
    } catch (SQLException e) {
        out.println("Error al cerrar recursos: " + e.getMessage());
    }
}
%>
