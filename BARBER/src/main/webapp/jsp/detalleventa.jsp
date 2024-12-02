 <%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="conexion.jsp" %>
<% 
HttpSession sesion = request.getSession();
int idusuarios = 0; 
String idusuariosString = (String) sesion.getAttribute("idusuarios");
if (idusuariosString != null && !idusuariosString.isEmpty()) {
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
    String clienteParam = request.getParameter("idclientesfk");
    String productoParam = request.getParameter("idproductos_serviciosfk");
    String fecha = request.getParameter("fecha");
    String det_cantidad = request.getParameter("det_cantidad");
    String numero = request.getParameter("numero");
    String condicion = request.getParameter("condicion");

    String[] clienteParts = clienteParam.split(",");
    String idclientesfk = clienteParts[0].trim();
    String ruc = clienteParts[1].trim();

    String[] productoParts = productoParam.split(",");
    String idproductos_serviciosfk = productoParts[0].trim();
    String det_precio = productoParts[1].trim();
    

    Statement st = null;
    ResultSet rs = null;
    ResultSet pk = null;

    try {
        st = conn.createStatement();
        rs = st.executeQuery("SELECT idtipofk, stock FROM productos_servicios WHERE idproductos_servicios='" + idproductos_serviciosfk + "'");
        int stockActual = 0;
        int idTipo = 0;
        
        if (rs.next()) {
            idTipo = rs.getInt("idtipofk");
            if (idTipo == 42) {
                stockActual = rs.getInt("stock");
            }
        }
        
        int cantidadVender = Integer.parseInt(det_cantidad);
        if (idTipo == 42 && (cantidadVender > stockActual || stockActual <= 0)) {
%>
<div class="alert alert-danger" role="alert">
    No hay suficiente stock disponible para realizar esta venta. Por favor, verifique el stock e intente nuevamente.
</div>
<%
        } else {
            rs = st.executeQuery("SELECT idventas FROM ventas WHERE estado='PENDIENTE'");
            if (rs.next()) {
                st.executeUpdate("INSERT INTO detalleventa(idventasfk, idproductos_serviciosfk, det_cantidad, det_precio) VALUES('" + rs.getString(1) + "','" + idproductos_serviciosfk + "','" + det_cantidad + "','" + det_precio + "')");
            } else {
                st.executeUpdate("INSERT INTO ventas(idclientesfk, fecha, idusuariosfk, numero, condicion) VALUES('" + idclientesfk + "','" + fecha + "', " + idusuariosfk + ", '" + numero + "', '" + condicion + "')");

                pk = st.executeQuery("SELECT idventas FROM ventas WHERE estado='PENDIENTE'");
                if (pk.next()) {
                    st.executeUpdate("INSERT INTO detalleventa(idventasfk, idproductos_serviciosfk, det_cantidad, det_precio) VALUES('" + pk.getString(1) + "','" + idproductos_serviciosfk + "','" + det_cantidad + "','" + det_precio + "')");
                }
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
        pk = st.executeQuery("SELECT idventas FROM ventas WHERE estado='PENDIENTE'");
        if (pk.next()) {
            rs = st.executeQuery("SELECT dt.iddetalleventa, p.descripcion, dt.det_precio, dt.det_cantidad, p.iva FROM detalleventa dt, productos_servicios p WHERE dt.idproductos_serviciosfk = p.idproductos_servicios AND dt.idventasfk = '" + pk.getString(1) + "' ORDER BY dt.iddetalleventa");
            while (rs.next()) {
                String det_precio = rs.getString(3);
                String det_cantidad = rs.getString(4);
                String iva = rs.getString(5);

                Integer precioI = Integer.parseInt(det_precio);
                Integer cantidadI = Integer.parseInt(det_cantidad);
                int calculo = precioI * cantidadI;

                // Calcular el IVA basado en el valor guardado
                int ivaCalculo = 0;
                if ("5".equals(iva)) {
                    ivaCalculo = calculo / 21;
                } else if ("10".equals(iva)) {
                    ivaCalculo = calculo / 11;
                } else if ("0".equals(iva)) {
                    ivaCalculo = 0; // IVA del 0%, no se aplica ningún cálculo
                }

                // Variables para cada columna de IVA
                int iva0 = 0;
                int iva5 = 0;
                int iva10 = 0;

                // Posicionar el IVA en la columna correcta
                if ("5".equals(iva)) {
                    iva5 = ivaCalculo;
                } else if ("10".equals(iva)) {
                    iva10 = ivaCalculo;
                } else if ("0".equals(iva)) {
                    iva0 = ivaCalculo;
                }

                // Calcular el total del producto (sin IVA)
                int total = calculo;
                // Calcular el subtotal del IVA (acumulando las tres tasas)
                int subtotalIVA = iva0 + iva5 + iva10;

%>
<tr>
    <td>
        <% if (sesion.getAttribute("rol").equals("ADMINISTRADOR")) { %>
        <i class="fa fa-trash" style="color:red" data-toggle="modal" data-target="#exampleModal" onclick="$('#idpk').val(<%= rs.getString(1) %>);"></i>
        <% } %>
    </td>
    <td><%= rs.getString(2) %></td> <!-- Descripción del producto -->
    <td><%= rs.getString(3) %></td> <!-- Precio del producto -->
    <td><%= rs.getString(4) %></td> <!-- Cantidad del producto -->
    <td><%= iva0 %></td>           <!-- IVA 0% -->
    <td><%= iva5 %></td>           <!-- IVA 5% -->
    <td><%= iva10 %></td>          <!-- IVA 10% -->
    <td><%= subtotalIVA %></td>     <!-- Subtotal del IVA -->
    <td><%= total %></td>          <!-- Total del producto -->
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
} else if (request.getParameter("listar").equals("mostrartotales")) {
    try {
        Statement st = null;
        ResultSet rs = null;
        ResultSet pk = null;
        int sumador = 0;
        st = conn.createStatement();
        pk = st.executeQuery("SELECT idventas FROM ventas WHERE estado='PENDIENTE'");
        if (pk.next()) {
            rs = st.executeQuery("SELECT dt.iddetalleventa, p.descripcion, dt.det_precio, dt.det_cantidad, iva FROM detalleventa dt, productos_servicios p WHERE dt.idproductos_serviciosfk = p.idproductos_servicios AND dt.idventasfk = '" + pk.getString(1) + "' ORDER BY dt.iddetalleventa");
            while (rs.next()) {
                String precio = rs.getString(3);
                String cantidad = rs.getString(4);
                Integer precioI = Integer.parseInt(precio);
                Integer cantidadI = Integer.parseInt(cantidad);
                int calculo = precioI * cantidadI;
                sumador += calculo;
            }
        }
        out.println(sumador);
    } catch (Exception e) {
        out.println("error PSQL: " + e.getMessage());
    }
} else if (request.getParameter("listar").equals("mostrarsubtotales")) {
    try {
        Statement st = null;
        ResultSet rs = null;
        ResultSet pk = null;
        int subtotalIVA = 0;
        st = conn.createStatement();
        pk = st.executeQuery("SELECT idventas FROM ventas WHERE estado='PENDIENTE'");
        if (pk.next()) {
            rs = st.executeQuery("SELECT dt.iddetalleventa, p.descripcion, dt.det_precio, dt.det_cantidad, iva FROM detalleventa dt, productos_servicios p WHERE dt.idproductos_serviciosfk = p.idproductos_servicios AND dt.idventasfk = '" + pk.getString(1) + "' ORDER BY dt.iddetalleventa");
            while (rs.next()) {
                String precio = rs.getString(3);
                String cantidad = rs.getString(4);
                String iva = rs.getString(5);
                
                Integer precioI = Integer.parseInt(precio);
                Integer cantidadI = Integer.parseInt(cantidad);
                int calculo = precioI * cantidadI;

                // Calcular el IVA basado en el valor guardado
                int ivaCalculo = 0;
                if ("5".equals(iva)) {
                    ivaCalculo = calculo / 21;
                } else if ("10".equals(iva)) {
                    ivaCalculo = calculo / 11;
                } else if ("0".equals(iva)) {
                    ivaCalculo = 0;
                }

                // Acumular el IVA calculado
                subtotalIVA += ivaCalculo;
            }
        }
        out.println(subtotalIVA);
    } catch (Exception e) {
        out.println("error PSQL: " + e.getMessage());
    }
} else if (request.getParameter("listar").equals("eliminardetalle")) {
    String pk = request.getParameter("pk");
    try {
        Statement st = conn.createStatement();
        st.executeUpdate("DELETE FROM detalleventa WHERE iddetalleventa='" + pk + "'");
    } catch (SQLException e) {
        out.println("error PSQL: " + e.getMessage());
    }
} else if (request.getParameter("listar").equals("cancelarventa")) {
    try {
        Statement st = null;
        ResultSet pk = null;
        st = conn.createStatement();
        pk = st.executeQuery("SELECT idventas FROM ventas WHERE estado='PENDIENTE'");
        if (pk.next()) {
            st.executeUpdate("UPDATE ventas SET estado='CANCELADO' WHERE idventas='" + pk.getString(1) + "'");
            //out.print("Venta cancelada exitosamente");
        }
    } catch (Exception e) {
        out.println("error PSQL: " + e.getMessage());
    }
} else if (request.getParameter("listar").equals("finalizarventa")) {
    Statement st = null;
    ResultSet rs = null;
    try {
        st = conn.createStatement();
        // Obtener el ID de la venta pendiente
        rs = st.executeQuery("SELECT idventas, fecha, condicion FROM ventas WHERE estado='PENDIENTE'");
        if (rs.next()) {
            int idVenta = rs.getInt("idventas");
            String fechaVenta = rs.getString("fecha");
            String condicion = rs.getString("condicion");

            // Actualizar el estado de la venta a 'FINALIZADO'
            st.executeUpdate("UPDATE ventas SET estado='FINALIZADO', total=" + request.getParameter("total") + " WHERE idventas=" + idVenta);

            // Si la condición es crédito, crear una cuenta cliente
            if ("credito".equals(condicion)) {
                // Calcular la fecha de vencimiento (30 días después de la fecha de venta)
                SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
                Date fecha = sdf.parse(fechaVenta);
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(fecha);
                calendar.add(Calendar.DAY_OF_MONTH, 30);
                String fechaVencimiento = sdf.format(calendar.getTime());

                // Insertar un nuevo registro en la tabla cuentaclientes
                String sqlInsertCuentaCliente = "INSERT INTO cuentaclientes (monto, cuota, nrocuota, vencimiento, estado, idventasfk) " +
                                                "VALUES (" + request.getParameter("total") + ", 1, 1, '" + fechaVencimiento + "', 'PENDIENTE', " + idVenta + ")";
                st.executeUpdate(sqlInsertCuentaCliente);
            }
        }
    } catch (SQLException e) {
        out.println("Error al finalizar la venta: " + e.getMessage());
    }
} else if (request.getParameter("listar").equals("listarventas")) {
    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();
        rs = st.executeQuery("select v.fecha, v.condicion, c.nombre, c.apellido, c.ruc, v.total, v.idventas from ventas v, clientes c where v.idclientesfk = c.idclientes and v.estado='FINALIZADO' ORDER BY v.idventas");
        while (rs.next()) {

%>
<tr>
    <td><% out.print(rs.getString(7)); %></td>
    <td><% out.print(rs.getString(1)); %></td>
    <td><% out.print(rs.getString(2)); %></td>
    <td><% out.print(rs.getString(3)); %></td>
    <td><% out.print(rs.getString(4) + ' ' + rs.getString(5)); %></td>
    <td><% out.print(rs.getString(6)); %></td>
    <td>
        <% if (sesion.getAttribute("rol").equals("ADMINISTRADOR")) {%>
        <button class="btn btn-outline-secondary" onclick="prepararImpresion('<% out.print(rs.getString(7)); %>')" title="Imprimir"> <img src="images/impresora.png" title="Imprimir" data-toggle="modal" data-target="#Imprimir"> 
        </button>
        <button class="btn btn-outline-danger" onclick="$('#idpk').val(<% out.print(rs.getString(7)); %>)" title="Anular" data-toggle="modal" data-target="#exampleModal">
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

    } else if (request.getParameter("listar").equals("anularventa")) {
    try {
        Statement st = null;
        ResultSet rs = null;

        st = conn.createStatement();
        String idVenta = request.getParameter("pkd");

        // Obtener detalles de productos vendidos en la venta a anular
        rs = st.executeQuery("SELECT id_producto, det_cantidad FROM detalleventa WHERE idventas='" + idVenta + "'");
        Map<String, Integer> productosRestaurar = new HashMap<>(); // Mapa para almacenar cantidades a restaurar

        while (rs.next()) {
            String idProducto = rs.getString("id_producto");
            int cantidad = rs.getInt("det_cantidad");

            // Verificar el tipo del producto
            ResultSet rsTipo = st.executeQuery("SELECT idcategoria FROM productos WHERE id_producto='" + idProducto + "'");
            if (rsTipo.next()) {
                int idTipo = rsTipo.getInt("idcategoria");
                // Solo agregar al mapa si el idtipofk es 42
                if (idTipo < 6) {
                    if (productosRestaurar.containsKey(idProducto)) {
                        productosRestaurar.put(idProducto, productosRestaurar.get(idProducto) + cantidad);
                    } else {
                        productosRestaurar.put(idProducto, cantidad);
                    }
                }
            }
            rsTipo.close();
        }

        // Restaurar el stock de productos
        for (Map.Entry<String, Integer> entry : productosRestaurar.entrySet()) {
            String idProducto = entry.getKey();
            int cantidadRestaurar = entry.getValue();


            st.executeUpdate("update productos set cantidad = cantidad + " + cantidadRestaurar + " where id_producto='" + idProducto + "'");
        }


        st.executeUpdate("update ventas set estado='ANULADO' where idventas='" + idVenta + "'");
        st.executeUpdate("update cuentasclientes set estado='ANULADO' where idventas='" + idVenta + "'");
        out.println("<i class='alert alert-success'>Datos eliminados</i>");
    } catch (SQLException e) {
        out.println("error PSQL" + e);
    }
}

%>

