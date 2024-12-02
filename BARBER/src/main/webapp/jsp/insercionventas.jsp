<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="conexion.jsp" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>

<%
  HttpSession sesion = request.getSession();
  String mensajeValidacion = ""; // Variable para almacenar el mensaje de validación
  Statement st = null;
  ResultSet rs = null;
  ResultSet pkResultSet = null;

  try {
      st = conn.createStatement();
      String listar = request.getParameter("listar");

      if (listar != null) {
          if (listar.equals("cargar")) {
              // Obtener datos para la cabecera
              String codalumno = request.getParameter("codalumno");
              String fecharegistro = request.getParameter("fecharegistro");
              String codproducto = request.getParameter("codproducto");
              String precioStr = request.getParameter("precio");
              String cantidadStr = request.getParameter("cantidad");
              String condicion = request.getParameter("condicion");

              // Validar y convertir precio y cantidad a enteros
              int precio = 0;
              int cantidad = 0;
              try {
                  precio = Integer.parseInt(precioStr);
                  cantidad = Integer.parseInt(cantidadStr);
              } catch (NumberFormatException e) {
                  mensajeValidacion = "<i class='alert alert-danger'>Error: El precio o la cantidad no es un número válido.</i>";
              }

              // Validar que los parámetros no sean nulos o vacíos
              if (codalumno == null || codalumno.isEmpty() ||
                  fecharegistro == null || fecharegistro.isEmpty() ||
                  codproducto == null || codproducto.isEmpty() ||
                  precio <= 0 || cantidad <= 0) {

                  mensajeValidacion = "<i class='alert alert-danger'>Por favor, complete todos los campos correctamente.</i>";
              } else {
                  // Verificar si el producto pertenece a una categoría entre 1 y 5
                  rs = st.executeQuery("SELECT id_categoria, cantidad FROM productos WHERE id_producto = '" + codproducto + "'");
                  if (rs.next()) {
                      int idCategoria = rs.getInt("id_categoria");
                      int stockDisponible = rs.getInt("cantidad");

                      // Si la categoría está entre 1 y 5, validamos el stock
                      if (idCategoria >= 1 && idCategoria <= 5) {
                          if (cantidad > stockDisponible) {
                              mensajeValidacion = "<i class='alert alert-danger'>Error: No hay suficiente cantidad disponible. Stock disponible: " + stockDisponible + ".</i>";
                          } else {
                              // Si hay suficiente stock, proceder con la venta
                              rs = st.executeQuery("SELECT id FROM ventas WHERE estado='pendiente'");
                              if (rs.next()) {
                                  // Si hay cabecera, insertar detalle
                                  st.executeUpdate("INSERT INTO detalleventas(idventa, cantidad, precio, id_producto) VALUES (" + rs.getString(1) + ", " + cantidad + ", " + precio + ", '" + codproducto + "')");
                                  mensajeValidacion = "<i class='alert alert-success'>Detalle cargado</i>";
                              } else {
                                  // Insertar cabecera y luego detalle
                                  st.executeUpdate("INSERT INTO ventas(id_cliente, fecha, estado, condicion) VALUES ('" + codalumno + "', '" + fecharegistro + "', 'pendiente',  '" + condicion + "')");
                                  pkResultSet = st.executeQuery("SELECT id FROM ventas WHERE estado='pendiente'");
                                  if (pkResultSet.next()) {
                                      st.executeUpdate("INSERT INTO detalleventas(idventa, cantidad, precio, id_producto) VALUES (" + pkResultSet.getString(1) + ", " + cantidad + ", " + precio + ", '" + codproducto + "')");
                                      mensajeValidacion = "<i class='alert alert-success'>Datos cargados</i>";
                                  } else {
                                      mensajeValidacion = "No se encontró la venta pendiente para insertar el detalle.";
                                  }
                              }
                          }
                      } else if (idCategoria == 6) {
                          // Si la categoría es 6, no se valida el stock y se permite la inserción
                          rs = st.executeQuery("SELECT id FROM ventas WHERE estado='pendiente'");
                          if (rs.next()) {
                              // Si hay cabecera, insertar detalle
                              st.executeUpdate("INSERT INTO detalleventas(idventa, cantidad, precio, id_producto) VALUES (" + rs.getString(1) + ", " + cantidad + ", " + precio + ", '" + codproducto + "')");
                              mensajeValidacion = "<i class='alert alert-success'>Detalle cargado (sin validación de stock)</i>";
                          } else {
                              // Insertar cabecera y luego detalle
                              st.executeUpdate("INSERT INTO ventas(id_cliente, fecha, estado, condicion) VALUES ('" + codalumno + "', '" + fecharegistro + "', 'pendiente',  '" + condicion + "')");
                              pkResultSet = st.executeQuery("SELECT id FROM ventas WHERE estado='pendiente'");
                              if (pkResultSet.next()) {
                                  st.executeUpdate("INSERT INTO detalleventas(idventa, cantidad, precio, id_producto) VALUES (" + pkResultSet.getString(1) + ", " + cantidad + ", " + precio + ", '" + codproducto + "')");
                                  mensajeValidacion = "<i class='alert alert-success'>Datos cargados </i>";
                              } else {
                                  mensajeValidacion = "No se encontró la venta pendiente para insertar el detalle.";
                              }
                          }
                      } else {
                          mensajeValidacion = "<i class='alert alert-danger'>Este producto no está en las categorías 1 a 5, por lo que no se puede realizar la validación de stock.</i>";
                      }
                  }else {
                      mensajeValidacion = "<i class='alert alert-danger'>Error: El producto no existe.</i>";
                  }
              }
          }else if (listar.equals("listar")) {
                // Listar detalles de venta
                pkResultSet = st.executeQuery("SELECT id FROM ventas WHERE estado='pendiente'");
                if (pkResultSet.next()) {
                    rs = st.executeQuery("SELECT dt.id, p.descripcion, dt.precio, dt.cantidad, p.iva FROM detalleventas dt, productos p WHERE dt.id_producto = p.id_producto AND dt.idventa='" + pkResultSet.getString(1) + "';");
                    int sumador = 0;
                    int ivaTotal = 0; // Variable para acumular el total del IVA

                    while (rs.next()) {
                        String precio = rs.getString(3);
                        String cantidad = rs.getString(4);
                        String iva = rs.getString(5);
                        Integer precioI = Integer.parseInt(precio);
                        Integer cantidadI = Integer.parseInt(cantidad);
                        int calculo = precioI * cantidadI;

                        // Calcular el IVA basado en el valor guardado
                        int porcentajeIva = Integer.parseInt(iva); // Asumiendo que el valor de IVA es el porcentaje
                        int calculoIva = (calculo * porcentajeIva) / 100;

                        // Acumular el IVA total
                        ivaTotal += calculoIva;

%>
<tr>
    <td>
        <% if (sesion.getAttribute("rol").equals("ADMINISTRADOR")) { %>
        <button type="button" class="btn btn-outline-danger" style="color:red" data-toggle="modal" data-target="#exampleModal" onclick="$('#idpk').val(<%= rs.getString(1) %>);"> 
            <img src="img/papelera-de-reciclaje.png"></button>
        <% } %>
    </td>
    <td><%= rs.getString(2) %></td>
    <td><%= rs.getString(3) %></td>
    <td><%= rs.getString(4) %></td>
    <td><%= calculoIva %> (IVA <%= porcentajeIva %>%)</td> <!-- IVA -->
    <td><%= calculo %></td> <!-- Subtotal sin IVA -->
    <td><%= calculo + calculoIva %></td> <!-- Total con IVA (Subtotal + IVA) -->
</tr>

<%
                        sumador += calculo;
                    }
%>
<input type="hidden" id="qrtotal" value="<%= (sumador + ivaTotal) %>">
<%
                    // Mostrar el total de IVA y el total general (con IVA)
                    out.println("<tr><td colspan='5'>SubTotal Iva: " + sumador + "</td><td>Total General (con IVA): " + (sumador + ivaTotal) + "</td></tr>");
                } else {
                    out.println("<tr><td colspan='5'>No se encontraron ventas pendientes.</td></tr>");
                }
            } else if (listar.equals("eliminardetalle")) {
                // Eliminar detalle de venta
                String detallePk = request.getParameter("pk");
                st.executeUpdate("DELETE FROM detalleventas WHERE id='" + detallePk + "'");
                mensajeValidacion = "<i class='alert alert-success'>Datos eliminados</i>";
            } else if (listar.equals("cancelarventa")) {
                // Cancelar venta
                pkResultSet = st.executeQuery("SELECT id FROM ventas WHERE estado='pendiente'");
                if (pkResultSet.next()) {
                    st.executeUpdate("UPDATE ventas SET estado='Cancelado' WHERE id='" + pkResultSet.getString(1) + "'");
                    mensajeValidacion = "<i class='alert alert-success'>Venta cancelada</i>";
                } else {
                    mensajeValidacion = "No se encontró la venta pendiente para cancelar.";
                }
            } else if (listar.equals("finalizarventa")) {
                // Finalizar venta
                pkResultSet = st.executeQuery("SELECT id, fecha, condicion FROM ventas WHERE estado='pendiente'");
                if (pkResultSet.next()) {
                    int idVenta = pkResultSet.getInt("id");
                    String fechaVenta = pkResultSet.getString("fecha");
                    String condicion = pkResultSet.getString("condicion");

                    // Calcular el total de la compra finalizada con IVA
                    rs = st.executeQuery("SELECT SUM(dt.precio * dt.cantidad * (1 + (p.iva / 100.0))) FROM detalleventas dt JOIN productos p ON dt.id_producto = p.id_producto WHERE dt.idventa='" + idVenta + "'");
                    if (rs.next()) {
                        double totalConIva = rs.getDouble(1);
                        st.executeUpdate("UPDATE ventas SET estado='Finalizado', total=" + totalConIva + " WHERE id='" + idVenta + "'");
                        mensajeValidacion = "<i class='alert alert-success'>Venta finalizada. Total con IVA: " + totalConIva + "</i>";

                        // Si la condición es crédito, crear una cuenta cliente
                        if ("credito".equalsIgnoreCase(condicion)) {
                            // Calcular la fecha de vencimiento (30 días después de la fecha de venta)
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                            Date fecha = sdf.parse(fechaVenta);
                            Calendar calendar = Calendar.getInstance();
                            calendar.setTime(fecha);
                            calendar.add(Calendar.DAY_OF_MONTH, 30);
                            String fechaVencimiento = sdf.format(calendar.getTime());

                            // Insertar un nuevo registro en la tabla cuentasclientes
                            String sqlInsertCuentaCliente = "INSERT INTO cuentasclientes (monto, cuota, nrocuota, vencimiento, estado, idventas) " +
                                                            "VALUES (" + totalConIva + ", 1, 1, '" + fechaVencimiento + "', 'PENDIENTE', " + idVenta + ")";
                            st.executeUpdate(sqlInsertCuentaCliente);
                        }

                        // Listar clientes asociados a la venta finalizada
                        rs = st.executeQuery("SELECT c.nombre, c.ci FROM ventas v JOIN clientes c ON v.id_cliente = c.id_cliente WHERE v.id='" + idVenta + "'");
                        while (rs.next()) {
%>
<tr>
    <td><%= rs.getString("nombre") %></td>
    <td><%= rs.getString("ci") %></td>
</tr>
<% 
                        }
%>
<!-- Aquí va el valor data-monto -->
<div id="montoFinal" data-monto="<%= totalConIva %>">
    Monto Total: <%= totalConIva %>
</div>
        
<%
                    } else {
                        mensajeValidacion = "Error al calcular el total de la compra.";
                    }
                } else {
                    mensajeValidacion = "No se encontró la venta pendiente para finalizar.";
                }
            } else if (listar.equals("listarventas")) {
                // Listar ventas finalizadas
                rs = st.executeQuery("SELECT to_char(v.fecha, 'dd-mm-yyyy') AS fecha_formateada, a.nombre, a.ci, v.total,v.condicion, v.id FROM ventas v JOIN clientes a ON v.id_cliente = a.id_cliente WHERE v.estado ='Finalizado';");
                
                boolean hayVentas = false; // Bandera para verificar si hay ventas
                while (rs.next()) {
                    hayVentas = true; // Hay al menos una venta
%>
<tr>
    <td><%= rs.getString(6) %></td>
    <td><%= rs.getString(1) %></td>
    <td><%= rs.getString(2) + ' ' + rs.getString(3) %></td>
    <td><%= rs.getString(4) %></td>
    <td><%= rs.getString(5) %></td>
    <td>
      <% if (sesion.getAttribute("rol").equals("ADMINISTRADOR")) { %>
      <button class="btn btn-outline-secondary" onclick="$('#pkim').val('<%= rs.getString(6) %>')" title="Imprimir"> 
            <img src="img/impresora (1).png" title="Imprimir" data-toggle="modal" data-target="#Imprimir"> 
        </button>
        <button type="button" class="btn btn-outline-danger" style="color:red" data-toggle="modal" data-target="#exampleModal" onclick="$('#idpk').val(<%= rs.getString(6) %>);"> 
            <img src="img/papelera-de-reciclaje.png"></button>
       <% } %>
    </td>
</tr>
<%
                }
                
                if (!hayVentas) {
                    out.println("<tr><td colspan='5'>No se encontraron ventas finalizadas.</td></tr>");
                }
            } else if (listar.equals("anularcompra")) {
                // Anular venta y restaurar productos al inventario
                String pkd = request.getParameter("pkd"); // ID de la venta
                if (pkd != null) {
                    // Recuperar los productos vendidos en la venta que será anulada
                    rs = st.executeQuery("SELECT dt.id_producto, dt.cantidad FROM detalleventas dt WHERE dt.idventa='" + pkd + "'");
                    while (rs.next()) {
                        String idProducto = rs.getString("id_producto");
                        int cantidadVendida = rs.getInt("cantidad");

                        // Restaurar la cantidad de los productos en el inventario
                        st.executeUpdate("UPDATE productos SET cantidad = cantidad + " + cantidadVendida + " WHERE id_producto = '" + idProducto + "'");
                    }

                    // Cambiar el estado de la venta a 'Anulado'
                    st.executeUpdate("UPDATE ventas SET estado='Anulado' WHERE id='" + pkd + "'");

                    mensajeValidacion = "<i class='alert alert-success'>Venta anulada y cantidades restauradas</i>";
                } else {
                    mensajeValidacion = "<i class='alert alert-danger'>Error: ID de venta no especificado.</i>";
                }
            }
        }
    } catch (SQLException e) {
        mensajeValidacion = "Error al ejecutar consulta SQL: " + e.getMessage();
    } finally {
        // Cerrar recursos
        try {
            if (rs != null) rs.close();
            if (pkResultSet != null) pkResultSet.close();
            if (st != null) st.close();
            if (conn != null) conn.close(); // Asegúrate de cerrar la conexión si es necesario
        } catch (SQLException e) {
            mensajeValidacion += " Error al cerrar recursos: " + e.getMessage();
        }
    }
%>

<!-- Mostrar el mensaje de validación debajo del formulario -->
<%
if (!mensajeValidacion.isEmpty()) {
    out.println(mensajeValidacion);
}
%>
  