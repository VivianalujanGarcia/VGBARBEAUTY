<%@ include file="conexion.jsp" %>

<%    
 
    // Obtener parámetros del request
    String fecha = request.getParameter("fecha");
    String estado = request.getParameter("estado");
    String idaperturas = request.getParameter("idaperturas");
    String idproveedores = request.getParameter("idproveedores");

    // Debug: Verificar que se están recibiendo los parámetros correctamente
    out.println("Fecha: " + fecha + "<br>");
    out.println("Estado: " + estado + "<br>");
    out.println("idaperturas: " + idaperturas + "<br>");
    out.println("idproveedores: " + idproveedores + "<br>");

    Statement st = null;
    ResultSet rs = null;

    try {
        st = conn.createStatement();
        
        // Verificar si ya existe un pago pendiente
        rs = st.executeQuery("SELECT idpagos FROM pagos WHERE estado='PENDIENTE'");
        
        if (!rs.next()) {
            // Insertar el nuevo pago si no hay pagos pendientes
            String sql = "INSERT INTO pagos (fecha, estado, idaperturas, idproveedores) VALUES ('" + fecha + "', 'PENDIENTE', '" + idaperturas + "','" + idproveedores + "')";
            st.executeUpdate(sql);
            out.print("Pago registrado exitosamente");
        } else {
            // Si ya hay un pago pendiente, mostrar mensaje de advertencia
            out.print("DEBE CERRAR CAJA PARA REALIZAR UN NUEVO PAGO");
        }
    } catch (SQLException e) {
        // Mostrar mensaje de error en caso de excepción
        out.print("Error al registrar el pago: " + e.getMessage());
    } finally {
        // Cerrar recursos de ResultSet y Statement
        try {
            if (rs != null) rs.close();
            if (st != null) st.close();
        } catch (SQLException e) {
            out.print("Error al cerrar los recursos: " + e.getMessage());
        }
    }
%>
