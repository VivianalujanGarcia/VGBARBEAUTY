<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ page contentType="application/json; charset=UTF-8" %>
<%@ include file="conexion.jsp" %>

<%
    // Crear objeto para almacenar los totales y los movimientos
    JSONObject jsonResponse = new JSONObject();

    if (request.getParameter("listar") != null && request.getParameter("listar").equals("listarmovimiento")) {
        try {
            Statement st = conn.createStatement();
            // Realizar la consulta para obtener datos de ventas, compras, cobros y pagos
            String query = "SELECT "
                    + "v.numero_venta, "
                    + "c.numero_compra, "
                    + "cc.numero_cobro, "
                    + "cp.numero_pago, " 
                    + "COALESCE(v.total, 0) AS total_ventas, "
                    + "COALESCE(c.total, 0) AS total_compras, "
                    + "COALESCE(cc.monto, 0) AS total_cuentasclientes, "
                    + "COALESCE(cp.monto, 0) AS total_cuentasproveedores "
                    + "FROM ventas v "
                    + "LEFT JOIN compras c ON v.id = c.venta_id "
                    + "LEFT JOIN cuentasclientes cc ON v.id = cc.venta_id "
                    + "LEFT JOIN cuentasproveedores cp ON v.id = cp.compra_id "
                    + "WHERE v.estado = 'Finalizado' "
                    + "AND c.estado = 'Finalizado' "
                    + "AND cc.estado = 'PAGADO' "
                    + "AND cp.estado = 'PAGADO';";
            
            ResultSet rs = st.executeQuery(query);
            JSONArray movimientosArray = new JSONArray();
            double totalVentas = 0;
            double totalCompras = 0;
            double totalCobros = 0;
            double totalPagos = 0;

            while (rs.next()) {
                JSONObject movimiento = new JSONObject();
                movimiento.put("numeroVenta", rs.getString("numero_venta") != null ? rs.getString("numero_venta") : "-");
                movimiento.put("numeroCompra", rs.getString("numero_compra") != null ? rs.getString("numero_compra") : "-");
                movimiento.put("numeroCobro", rs.getString("numero_cobro") != null ? rs.getString("numero_cobro") : "-");
                movimiento.put("numeroPago", rs.getString("numero_pago") != null ? rs.getString("numero_pago") : "-");

                // Calcular el monto total
                double venta = rs.getDouble("total_ventas");
                double compra = rs.getDouble("total_compras");
                double cobro = rs.getDouble("total_cuentasclientes");
                double pago = rs.getDouble("total_cuentasproveedores");

                double montoTotal = venta + compra + cobro + pago;
                movimiento.put("montoTotal", montoTotal);

                // Acumular los totales
                totalVentas += venta;
                totalCompras += compra;
                totalCobros += cobro;
                totalPagos += pago;

                // Agregar el movimiento al array
                movimientosArray.put(movimiento);
            }

            // Agregar los movimientos al JSON final
            jsonResponse.put("movimientos", movimientosArray);
            jsonResponse.put("totalVentas", totalVentas);
            jsonResponse.put("totalCompras", totalCompras);
            jsonResponse.put("totalCobros", totalCobros);
            jsonResponse.put("totalPagos", totalPagos);

            // Si no hay datos, retornar un mensaje indicando eso
            if (movimientosArray.length() == 0) {
                jsonResponse.put("mensaje", "No hay movimientos registrados");
            }

            // Escribir el JSON como respuesta
            out.print(jsonResponse.toString());

            rs.close();
            st.close();
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.put("error", "Error en la consulta: " + e.getMessage());
            out.print(jsonResponse.toString());
        }
    }
%>
